// improve from Session1/27-Rim Bump Texture with Tiling Offset

Shader "ShaderSuperb/Session2/13-Rim Bump Texture with Tiling Offset Shadow SkyReflection Fog"
{
    Properties
    {
        _MainTex("Main Texture",2D)= "gray" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        //边缘发光颜色 
        _RimColor("Rim Color", Color) = (0.5,0.5,0.5,1)  
        //边缘发光强度
        _RimPower("Rim Power", Range(0.0, 36)) = 6
        //边缘发光强度系数 
        _RimIntensity("Rim Intensity", Range(0.0, 100)) = 3  
         _FogUVFactor("fogUVFactor",float) = 1.0
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
            //Needed for fog variation to be compiled.
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            uniform sampler2D  _MainTex;
            uniform float4 _MainTex_ST;
            uniform sampler2D _BumpMap;
            uniform float4 _BumpMap_ST;
            uniform float4 _LightColor0;
            //边缘光颜色  
            uniform float4 _RimColor;  
            //边缘光强度  
            uniform float _RimPower;  
            //边缘光强度系数  
            uniform float _RimIntensity; 
            float _FogUVFactor;

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
                float3 worldSpaceVertexPos:COLOR1;
                float3 worldSpaceNormalDir:COLOR2;
                //Used to pass fog amount around number should be a free texcoord.
                UNITY_FOG_COORDS(3)

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

                //世界空间中顶点坐标
                o.worldSpaceVertexPos = mul(unity_ObjectToWorld, v.vertex);
                //世界空间中法线方向
                o.worldSpaceNormalDir = normalize( mul( float4(v.normal,0.0),unity_WorldToObject).xyz );

                //Compute fog amount from clip space position.
                UNITY_TRANSFER_FOG(o,o.position);

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

                //世界空间中观察方向=归一化（世界空间中摄像机坐标-世界空间中顶点坐标）
                float3 WorldSpaceViewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldSpaceVertexPos);

                //----------------------------------
                //边缘光
                //计算边缘强度  rim用的菲涅尔反射公式。
                half Rim = 1.0 - max(0, dot(i.worldSpaceNormalDir, WorldSpaceViewDir));  
                //计算出边缘自发光强度  
                float3 Emissive = _RimColor.rgb * pow(Rim , _RimPower) *_RimIntensity; 

                //skybox cubemap数据
                float3 worldSpaceViewDir = normalize(UnityWorldSpaceViewDir(i.worldSpaceVertexPos));
                float3 worldSpaceReflectVector = reflect(-worldSpaceViewDir, i.worldSpaceNormalDir);
                // 使用世界空间反射向量采样默认的立方体贴图 || sample the default reflection cubemap, using the reflection vector
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldSpaceReflectVector);
                // 解码cubemap成颜色值 || decode cubemap data into actual color
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);

                //最终像素颜色
                float3 FinalColor = MainTexColor * BumpIntensity * skyColor + Emissive;

                UNITY_APPLY_FOG(i.fogCoord *_FogUVFactor, FinalColor); 

                return float4(FinalColor,1);
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

            struct v2f { 
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
