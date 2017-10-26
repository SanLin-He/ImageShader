// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
//马赛克
Shader "Mirror/Mosaic"
{
    Properties
    {
        _MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
        _SquareWidth("Square Width", Range(1, 100)) = 8
      
    }
    
    SubShader
    {
        LOD 200

        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }

        Pass
        {
            Cull Off
            Lighting Off
            ZWrite Off
            Fog { Mode Off }
            Offset -1, -1
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _SquareWidth;
            float4 _TexSize;
            float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };
    
            struct v2f
            {
                float4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };
    
            v2f o;

            v2f vert (appdata_t v)
            {
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }
                
            fixed4 frag (v2f IN) : COLOR
            {

			    //_MainTex_TexelSize.xy *_SquareWidth 每个格子的uv宽度
				float size = _MainTex_TexelSize.xy *_SquareWidth;
				float2 uv = floor(IN.uv/size)*size;
                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }

    
}