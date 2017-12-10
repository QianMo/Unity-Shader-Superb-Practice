//http://blog.csdn.net/liu_if_else/article/details/73506027

Shader "ShaderSuperb/Session16/3-DispersionTest"
{
	Properties{
		fresnelPower("fresnelPower",float) = 0
		fresnelScale("fresnelScale",float) = 0
		fresnelBias("fresnelBias",float) = 0
		_r("r",float) = 0
		_g("g",float) = 0
		_b("b",float) = 0

	}
		SubShader
	{
		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

	struct v2f {
		float3 normal:NORMAL;
		float3 worldRefra : TEXCOORD0;
		float4 pos : SV_POSITION;
		float4 objectPOS:float;
	};
	//在外部可改为power=4,scale=0.1,bias=-0.2
	float fresnelPower = 1.0f;
	float fresnelScale = 1.0f;
	float fresnelBias = 0.3f;
	//红，绿，蓝的折射率，从外部赋值，方便调整
	float3 etaRatio;// =float3(0.83f,0.67f,0.55f); //1/1.3 1/1.5 1/1.8
	float _r;
	float _g;
	float _b;
	v2f vert(float4 vertex : POSITION, float3 normal : NORMAL)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(vertex);
		o.normal = normal;
		o.objectPOS = vertex;
		return o;
	}
	//为了达到最佳效果，将所有计算都写在了片段着色器内。
	fixed4 frag(v2f i) : SV_Target
	{

		etaRatio = float3(_r,_g,_b);

	i.normal = UnityObjectToWorldNormal(i.normal);
	float3 worldPos = mul(unity_ObjectToWorld, i.objectPOS).xyz;
	float3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
	//反射向量
	float R = reflect(-worldViewDir,i.normal);

	i.normal = normalize(i.normal);
	//计算用来模拟色散的折射向量
	float3 Tred = refract(normalize(-worldViewDir),i.normal,etaRatio.x);
	float3 Tgreen = refract(normalize(-worldViewDir),i.normal,etaRatio.y);
	float3 Tblue = refract(normalize(-worldViewDir),i.normal,etaRatio.z);
	//菲涅尔factor，用来混合反射与折射颜色。
	float reflectionfactor = min(1.0f,max(0,fresnelBias + fresnelScale*pow(1.0f + dot(normalize(-worldViewDir),i.normal),fresnelPower)));
	//如果利用color存此变量，可以省去min与max。
	//     color reflectionfactor=fresnelBias+fresnelScale*pow(1.0f+dot(normalize(-worldViewDir),i.normal),fresnelPower);

	half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, R);
	//反射颜色
	float4 reflectedColor = half4(DecodeHDR(skyData, unity_SpecCube0_HDR),1.0f);

	float4 refractedColor;
	//折射颜色
	refractedColor.r = DecodeHDR(UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, Tred),unity_SpecCube0_HDR).r;
	refractedColor.g = DecodeHDR(UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, Tgreen),unity_SpecCube0_HDR).g;
	refractedColor.b = DecodeHDR(UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, Tblue),unity_SpecCube0_HDR).b;
	refractedColor.a = 1.0f;
	fixed4 c = 0;
	//混合
	c = lerp(refractedColor,reflectedColor,reflectionfactor.x);
	return c;

	}
		ENDCG
	}
	}
}