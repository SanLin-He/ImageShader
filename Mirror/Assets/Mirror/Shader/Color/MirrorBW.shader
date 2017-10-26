Shader "Mirror/BW"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_bwInstensity("bwInstensity", Range(0,1)) = 0.5
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _bwInstensity;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 c = tex2D(_MainTex, i.uv);

				//float lum = c.r*.3 + c.g*.59 + c.b*.11;
				//float3 bw = float3(lum, lum, lum);

				//float4 result = c;
				//result.rgb = lerp(c.rgb, bw, _bwInstensity);
				//return result;

				c.rgb = lerp(c.rgb, dot(c,float3(0.3, 0.59, 0.11)).xxx, _bwInstensity);
				return c;

			}
			ENDCG
		}
	}
}
