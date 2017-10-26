Shader "Mirro/DoubleEye" {
    Properties {
		 _MainTex ("Base (RGB)", 2D) = "white" {}
		 //_ColorMaskG ("Color MaskG", Float) = 15
		 //_ColorMaskR ("Color MaskR", Float) = 15
    }
    SubShader
    {
         Tags{"Queue"="Transparent"}
     
        pass
        {
			//ColorMask [_ColorMaskG]
            Name "pass1"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            } ;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
                o.uv =  TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }
            float4 frag (v2f i) : COLOR
            {
                float4 texCol = tex2D(_MainTex,i.uv+0.1) ;
                float4 outp;
                outp = texCol  * float4(1,0,0,1);
                return outp;
            }
            ENDCG
        }
       
        pass
        {
			//ColorMask [_ColorMaskR]
            Blend one one
            Name "pass2"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;
            struct v2f {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            } ;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
                o.uv =  TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }
            float4 frag (v2f i) : COLOR
            {
                float4 texCol = tex2D(_MainTex,i.uv);
                float4 outp;
                outp = texCol * float4(0,1,0,1);
                return outp;
            }
            ENDCG
        }
    }
}