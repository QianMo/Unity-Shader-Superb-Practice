// While the player is moving, textures change around him.
// Apply the material and the script on your objects.
// Your player gameobject must be called "Player"
 
// Shader : https://pastebin.com/596zc1py
// Script : https://pastebin.com/JxWdQFKZ

Shader "ShaderSuperb/Session19/Miscellaneous/TextureSwitch"
{
    Properties
    {
        _PlayerPos ("Player position", vector) = (0.0, 0.0, 0.0, 0.0)
        _Dist ("Distance", float) = 5.0
        _MainTex ("Texture", 2D) = "white" {}
        _SecondayTex ("Secondary texture", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
       
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
            };
 
            v2f vert(appdata_base v)
            {
                v2f o;
                // We compute the world position to use it in the fragment function
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }
 
            float4 _PlayerPos;
            sampler2D _MainTex;
            sampler2D _SecondayTex;
            float _Dist;
 
            fixed4 frag(v2f i) : SV_Target
            {
                // Depending the distance from the player, we use a different texture
                if(distance(_PlayerPos.xyz, i.worldPos.xyz) > _Dist)
                    return tex2D(_MainTex, i.uv);
                else
                    return tex2D(_SecondayTex, i.uv);
            }
 
            ENDCG
        }
    }
}