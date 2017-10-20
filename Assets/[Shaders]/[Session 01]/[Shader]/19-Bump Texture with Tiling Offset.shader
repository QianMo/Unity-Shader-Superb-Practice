
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
                //获取模型的顶点位置
                float4 vertex:POSITION;
                //获取模型的第一组纹理坐标
                float4 uv:TEXCOORD0;
                //获取模型的法线向量
                float3 normal : NORMAL;
                //获取模型的切线向量
                float4 tangent : TANGENT;
            };

            //---------------------------------
            //顶点输出，片元输入结构体
            struct v2f
            {
                //裁剪空间中顶点坐标
                float4 position:SV_POSITION;
                //主纹理坐标
                float2 mainTexUv :TEXCOORD0;
                //bump纹理坐标
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
                o.bumpTexUv = TRANSFORM_TEX(v.uv,_BumpMap);

                //副法线
                float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;

                //计算rotation变换矩阵
    			float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);

                //计算模型空间下的光照方向
  				float3 objectSpaceLightDir= mul(unity_WorldToObject, _WorldSpaceLightPos0).xyz;

                //计算模型空间下旋转后的光照方向
    			o.objectSpaceRotateLightDir=mul(rotation,normalize(objectSpaceLightDir));

                return o;
            }

            //=============================================
            //fragment函数需返回对应屏幕上该像素的颜色值
            float4 frag(v2f i):SV_Target
            {

                //获取主纹理
                float4 MainTexColor = tex2D(_MainTex, i.mainTexUv);

                //获取模型坐标下的凹凸法线方向
                float3 ObjectSpaceNormalDir = UnpackNormal(tex2D(_BumpMap,i.bumpTexUv));

                //法线凹凸强度 = 模型空间下凹凸法线方向 x 模型空间下光照方向
                float3 BumpIntensity = max(0, dot(ObjectSpaceNormalDir,i.objectSpaceRotateLightDir));

                //最终像素颜色
                float3 FinalColor = MainTexColor * BumpIntensity;

                return float4(FinalColor,1);
            }

            ENDCG
        }

    }
}
