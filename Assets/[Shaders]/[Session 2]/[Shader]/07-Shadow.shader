//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderSuperb/Session2/07-Shadow"
{
    Properties
    {
        _Color("Main Color",Color) = (1,1,1,1)
    }
    
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;

            //---------------------------------
            //顶点输入结构体
            //---------------------------------
            struct a2v
            {
                float4 vertex:POSITION;//从Unity获取顶点位置
                float3 normal:NORMAL;//从Unity获取法模型空间的线坐标
            };


            //---------------------------------
            //顶点输出，片元输入结构体
            //---------------------------------
            struct v2f 
            {
                float4 pos : SV_POSITION;
                float3 normal:COLOR0;
            };

            v2f vert (a2v v)
            {
                v2f o;
                //模型空间的坐标转换为裁剪空间中坐标
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal=v.normal;
                
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {

                return float4(i.normal *_Color,1);
            }
            ENDCG
        }

        //加上这个pass，就有阴影了。
		// shadow caster rendering pass, implemented manually
        // using macros from UnityCG.cginc
        Pass
        {
            Tags {"LightMode"="ShadowCaster"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct v2f 
            { 
                V2F_SHADOW_CASTER;
            };

			/*
			struct appdata_base {
			    float4 vertex : POSITION;
			    float3 normal : NORMAL;
			    float4 texcoord : TEXCOORD0;
			    UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			*/

            v2f vert(appdata_base v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }



    }
}