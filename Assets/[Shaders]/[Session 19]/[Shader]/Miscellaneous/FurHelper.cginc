#pragma target 3.0
#include "UnityCG.cginc"

struct v2f {
	float4 pos : SV_POSITION;
	half2 uv : TEXCOORD0;
	half2 uv1 : TEXCOORD1;
	fixed4 diff : COLOR;
};

float _FurLength;
sampler2D _MainTex;
float4 _MainTex_ST;
sampler2D _FurTex;
float4 _FurTex_ST;
float _Blur;

v2f vert(appdata_base v) {
	v2f o;
	v.vertex.xyz += v.normal * _FurLength * FURSTEP;
	o.pos = UnityObjectToClipPos(v.vertex);
	o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
	o.uv1 = TRANSFORM_TEX(v.texcoord, _FurTex);
	float3 worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));
	o.diff = LambertDiffuse(worldNormal);
	o.diff.a = 1 - (FURSTEP * FURSTEP);
	float4 worldPos = mul(unity_WorldToObject, v.vertex);
	o.diff.a += dot(normalize(_WorldSpaceCameraPos.xyz - worldPos), worldNormal) - _Blur;
	return o;
}

float _CutOff;
float _Thickness;

fixed4 frag(v2f i) : SV_Target {
	fixed4 col = tex2D(_MainTex, i.uv);
	fixed alpha = tex2D(_FurTex, i.uv1).r;
	col *= i.diff;
	col.a *= step(lerp(_CutOff, _CutOff + _Thickness, FURSTEP), alpha);
	return col;
}