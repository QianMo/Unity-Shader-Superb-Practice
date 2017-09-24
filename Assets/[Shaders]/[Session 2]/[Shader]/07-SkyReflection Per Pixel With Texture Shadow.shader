//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderSuperb/Session2/07-SkyReflection Per Pixel With Texture Shadow"
{
  Properties 
    {
        _MainTex("Base texture", 2D) = "white" {}
        _OcclusionMap("Occlusion", 2D) = "white" {}
        // normal map texture on the material,
        // default to dummy "flat surface" normalmap
        _BumpMap("Normal Map", 2D) = "bump" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _OcclusionMap;
            float4 _OcclusionMap_ST;
            sampler2D _BumpMap;
            uniform float4 _BumpMap_ST;

            //---------------------------------
            //顶点输入结构体
            //---------------------------------
            struct a2v
            {
                float4 vertex:POSITION;//从Unity获取顶点位置
                float3 normal:NORMAL;//从Unity获取法线坐标
                float4 tangent : TANGENT;//从Unity获取切线坐标
                float4 texcoordMainTex : TEXCOORD0; //从Unity获取第一组纹理坐标
                float4 texcoordBumpMap : TEXCOORD1; //从Unity获取第一组纹理坐标
                float4 texcoordOcclusionMap : TEXCOORD2; //从Unity获取第一组纹理坐标
            };


            //---------------------------------
            //顶点输出，片元输入结构体
            //---------------------------------
            struct v2f 
            {
                float3 worldSpaceVertexPos : TEXCOORD0;

                // these three vectors will hold a 3x3 rotation matrix
                // that transforms from tangent to world space
                half3 objectToWorldVector0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 objectToWorldVector1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 objectToWorldVector2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
                
                // texture coordinate
                float2 uvMainTex : TEXCOORD4; 
                float2 uvBumpMap : TEXCOORD5; 
                float2 uvOcclusionMap : TEXCOORD6;

                float4 pos : SV_POSITION;
            };

            v2f vert (a2v v)
            {
                v2f o;
                //模型空间的坐标转换为裁剪空间中坐标
                o.pos = UnityObjectToClipPos(v.vertex);
                // 世界空间中顶点坐标
                o.worldSpaceVertexPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                half3 wNormal = UnityObjectToWorldNormal(v.normal);
                half3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
                // compute bitangent from cross product of normal and tangent
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;

                // output the tangent space matrix
                o.objectToWorldVector0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.objectToWorldVector1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.objectToWorldVector2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.uvMainTex = TRANSFORM_TEX(v.texcoordMainTex,_MainTex);
                o.uvBumpMap = TRANSFORM_TEX(v.texcoordBumpMap,_BumpMap);
                o.uvOcclusionMap = TRANSFORM_TEX(v.texcoordOcclusionMap,_OcclusionMap);
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {

                // sample the normal map, and decode from the Unity encoding
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uvBumpMap));
                // transform normal from tangent to world space
                half3 worldSpaceNormalDir;
                worldSpaceNormalDir.x = dot(i.objectToWorldVector0, tnormal);
                worldSpaceNormalDir.y = dot(i.objectToWorldVector1, tnormal);
                worldSpaceNormalDir.z = dot(i.objectToWorldVector2, tnormal);

                float3 worldSpaceViewDir = normalize(UnityWorldSpaceViewDir(i.worldSpaceVertexPos));
                float3 worldSpaceReflectVector = reflect(-worldSpaceViewDir, worldSpaceNormalDir);
                // 使用世界空间反射向量采样默认的立方体贴图 || sample the default reflection cubemap, using the reflection vector
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldSpaceReflectVector);
                // 解码cubemap成颜色值 || decode cubemap data into actual color
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                // 
                fixed4 c = 0;
                c.rgb = skyColor;

                // modulate sky color with the base texture, and the occlusion map
                fixed3 baseColor = tex2D(_MainTex, i.uvMainTex).rgb;
                fixed occlusion = tex2D(_OcclusionMap, i.uvOcclusionMap).r;
                c.rgb *= baseColor;
                c.rgb *= occlusion;

                return c;
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