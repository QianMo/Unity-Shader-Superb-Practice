
Shader "ShaderSuperb/Session1/19-Bump Texture with Tiling Offset"
{
    Properties
    {
        _MainTex("Main Texture",2D)= "gray" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
    }

    //=========================================================================
    SubShader
    {
        Pass
        {
            Tags{"LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D  _MainTex;
            uniform float4 _MainTex_ST;
            uniform sampler2D _BumpMap;
            uniform float4 _BumpMap_ST;
            uniform float4 _LightColor0;

            //---------------------------------
            //顶点输入结构体
            struct a2v
            {
                float4 vertex:POSITION;//从Unity获取顶点位置
                float4 uv:TEXCOORD0;//获取模型的第一组纹理坐标
                float3 normal : NORMAL;//获取模型的法线向量
                float4 tangent : TANGENT;
            };

            //---------------------------------
            //顶点输出，片元输入结构体
            struct v2f
            {
                //裁剪空间中顶点坐标
                float4 position:SV_POSITION;
                //纹理坐标
                float2 mainTexUv :TEXCOORD0;
                //纹理坐标
                float2 bumpTexUv :TEXCOORD1;
                //模型空间中旋转后光线方向
                float3 objectSpaceRotateLightDir : TEXCOORD2;

            };

            //=============================================
            //vertex函数需至少完成顶点坐标从模型空间到裁剪空间的变换
            v2f vert(a2v v)
            {
                v2f o;
                //float4 UnityObjectToClipPos(float4 pos)等价于：mul(UNITY_MATRIX_MVP, float4(pos)),
                o.position = UnityObjectToClipPos(v.vertex);
 				//传递主纹理坐标
                o.mainTexUv = TRANSFORM_TEX(v.uv,_MainTex);
                //传递bump纹理坐标
                o.bumpTexUv=TRANSFORM_TEX(v.uv,_BumpMap);

                float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;

    			float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);

  				float3 objectSpaceLightDir= mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz;

    			o.objectSpaceRotateLightDir=mul(rotation,objectSpaceLightDir);

                return o;
            }

            //=============================================
            //fragment函数需返回对应屏幕上该像素的颜色值
            float4 frag(v2f i):SV_Target
            {

                //世界空间中法线方向
                //float3 WorldSpaceNormalDir = normalize(i.worldSpaceNormalDir);
                //平行光源的光线方向
                float3 WorldSpaceLightDir =  normalize( _WorldSpaceLightPos0.xyz);

                float4 MainTexColor = tex2D(_MainTex, i.mainTexUv);

                float3 NormalTex = UnpackNormal(tex2D(_BumpMap,i.bumpTexUv));

                float3 NormalDiffuse = max(0,dot(NormalTex,i.objectSpaceRotateLightDir));

                float3 FinalColor = MainTexColor * NormalDiffuse;

                return float4(FinalColor,1);
            }

            ENDCG
        }

    }
}
