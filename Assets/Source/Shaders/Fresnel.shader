Shader "Unlit/Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        _FresnelBias ("Fresnel Bias", Float) = 0
        _FresnelScale ("Fresnel Scale", Float) = 1
        _FresnelPower ("Fresnel Power", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            Stencil
            {
                Ref 7
                Comp Equal
                Pass Keep
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float fresnel : TEXCOORD0;
            };

            fixed4 _Color;
            fixed4 _FresnelColor;
            fixed _FresnelBias;
            fixed _FresnelScale;
            fixed _FresnelPower;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 multiplication = mul(unity_ObjectToWorld, float4(v.normal, 0.0));
                float3 normWorld = normalize(multiplication);
                float3 I = normalize(posWorld - _WorldSpaceCameraPos.xyz);
                o.fresnel = _FresnelBias + _FresnelScale * pow(1.0 + dot(I, normWorld), _FresnelPower);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float fresnel = clamp(i.fresnel, 0.0, 1.0);
                return lerp(_FresnelColor, _Color, fresnel);
            }
            ENDCG
        }        
    }
    FallBack "Transparent/VertexLit"
}
