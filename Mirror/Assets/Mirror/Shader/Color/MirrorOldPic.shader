Shader "Mirror/OldPic"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Noise("noise", 2D) = "white" {}
		_Res("Noise Resolution",Float) = 1
	}
	SubShader
	{
		tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Res;
			sampler2D _Noise;
			float4 _Noise_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
		
			float noise(float n) {
				return n * 0.5 + 0.5;
			}
			
			float colorBlend(float scale, float dest, float src) {
				return (scale * dest + (1.0 - scale) * src);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float n = tex2D(_Noise, i.uv).r ;
				float4 c = tex2D(_MainTex, i.uv);

				c.r = colorBlend(noise(n), c.r * 0.393 + c.g * 0.769 + c.b * 0.189, c.r);
				c.g = colorBlend(noise(n), c.r * 0.349 + c.g * 0.686 + c.b * 0.168, c.g);
				c.b = colorBlend(noise(n), c.r * 0.272 + c.g * 0.534 + c.b * 0.131, c.b);

				float4 result = c;			
				return result;

			}
			ENDCG
		}
	}
}
