

Shader "ShaderSuperb/Session1/14-Specular(Blinn–Phong) Reflection in Fragment"
{
	Properties
	{
		_DiffuseColor("Diffuse Color",Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10
	}

	//=========================================================================
	SubShader
	{
		Pass
		{
			//设置为前向渲染路径。保证Unity提供的内置变量值的正确性
			Tags { "LightMode" = "ForwardBase" }
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			//要用内置的光照颜色，定义uniform float4 _LightColor0或#include "Lighting.cginc" ;
			uniform float4 _LightColor0;
			//变量声明
			uniform float4 _DiffuseColor;
			uniform float4 _SpecColor;
			uniform float _Shininess;

			//---------------------------------
			//顶点输入结构体
			struct a2v
			{
				float4 vertex:POSITION;//从Unity获取顶点位置
				float3 normal:NORMAL;//从Unity获取法线坐标
			};

			//---------------------------------
			//顶点输出，片元输入结构体
			struct v2f
			{
				//裁剪空间中顶点坐标
				float4 position:SV_POSITION;

				float3 worldSpaceVertexPos:COLOR1;
				float3 worldSpaceNormalDir:COLOR2;
				//COLOR0和COLOR1等，可作为顶点和片段的输入输出的语义，是精度低，0–1范围内的数据（如简单的颜色值）可选为1维，二维，三维，四维的float，fixed，half
				//float4 color:COLOR3;

			};

			//=============================================
			//vertex函数需至少完成顶点坐标从模型空间到裁剪空间的变换
			v2f vert(a2v v)
			{
				//顶点坐标变换
				v2f o;
				//------------------------------------
				//准备数据，传递给fragment
				//模型空间的坐标转换为裁剪空间中坐标||float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
				o.position = UnityObjectToClipPos(v.vertex);
				//世界空间中顶点坐标
				o.worldSpaceVertexPos = mul(unity_ObjectToWorld, v.vertex);
				//世界空间中法线方向
				o.worldSpaceNormalDir = normalize( mul( float4(v.normal,0.0),unity_WorldToObject).xyz );

				return o;
			}

			//=============================================
			//fragment函数需返回对应屏幕上该像素的颜色值
			float4 frag(v2f i):SV_Target
			{

				//-----------------------------------
				//0、参数准备
				//世界空间中法线方向
				float3 WorldSpaceNormalDir = normalize(i.worldSpaceNormalDir);
				//平行光源的光线方向
				float3 WorldSpaceLightDir =  normalize( _WorldSpaceLightPos0.xyz);

				//-----------------------------------
				//1、计算Diffuse项
				//lambert漫反射的颜色=i_diffuse * i_incoming * k_diffuse *max(0,N*L)
				float AttenDiffuse = 1.0;
				float3 DiffuseReflection = AttenDiffuse *  _DiffuseColor.rgb * _LightColor0.rgb * max(0,dot(WorldSpaceNormalDir, WorldSpaceLightDir));


				//----------------------------------
				//2、计算Specular项
				float AttenSpecular = 1.0;
				//世界空间中镜面反射方向
				float3 WorldSpaceReflectionDir = normalize(reflect(-WorldSpaceLightDir,WorldSpaceNormalDir));
				//世界空间中观察方向=归一化（世界空间中摄像机坐标-世界空间中顶点坐标）
				float3 WorldSpaceViewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldSpaceVertexPos);

				//中间向量 H=（L+V）/(||L+V||)
				float3 HalfWayDir = normalize(WorldSpaceViewDir + WorldSpaceLightDir);

				//Blinn–Phong Specular = Atten * i_incoming * k_specular * max(0,N · H) ^ n_shiness
				float3 SpecularReflection = AttenSpecular * _LightColor0.xyz * _SpecColor.rgb * pow(max(0.0 , dot(WorldSpaceNormalDir,HalfWayDir)),_Shininess);

				//----------------------------------
				//3、获取环境光项
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				//----------------------------------
				//4、最终颜色
				float4 FinalColor = float4(DiffuseReflection + SpecularReflection+ ambient,1.0);


				//输出最终颜色
				return FinalColor;
			}

			ENDCG
		}

	}
}
