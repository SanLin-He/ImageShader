Shader "Mirror/Sharpen"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Bright ("bright",Float) = 1.14
		
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
			float4 _MainTex_TexelSize;

			float _Bright;

			//fixed _Lapacian[9]
			//	= {
			//	-1, -1, -1,
			//	-1, 9, -1,
			//	-1, -1, -1
			//}
			//;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed _Lapacian[9] = {
				-1, -1, -1,
				-1, 9, -1,
				-1, -1, -1
				};

				/*float4 pc = tex2D(_MainTex,i.uv + fixed2(-1,0) * _MainTex_TexelSize.xy);
				float4 c = tex2D(_MainTex, i.uv);
				float4 ac = tex2D(_MainTex, i.uv + fixed2(1, 0) * _MainTex_TexelSize.xy);
*/
				float4 newColor = 0;
				
				newColor += tex2D(_MainTex, i.uv + fixed2(-1, -1) * _MainTex_TexelSize.xy) * _Lapacian[0] * _Bright;
				newColor += tex2D(_MainTex, i.uv + fixed2(0, -1) * _MainTex_TexelSize.xy) * _Lapacian[1] * _Bright;
				newColor += tex2D(_MainTex, i.uv + fixed2(1, -1) * _MainTex_TexelSize.xy) * _Lapacian[2] * _Bright;

				newColor += tex2D(_MainTex, i.uv + fixed2(0, -1) * _MainTex_TexelSize.xy) * _Lapacian[3] * _Bright;
				newColor += tex2D(_MainTex, i.uv) * _Lapacian[4] * _Bright;
				newColor += tex2D(_MainTex, i.uv + fixed2(0, 1) * _MainTex_TexelSize.xy) * _Lapacian[5] * _Bright;

				newColor += tex2D(_MainTex, i.uv + fixed2(1, -1) * _MainTex_TexelSize.xy) * _Lapacian[6] * _Bright;
				newColor += tex2D(_MainTex, i.uv + fixed2(1, 0) * _MainTex_TexelSize.xy) * _Lapacian[7] * _Bright;
				newColor += tex2D(_MainTex, i.uv + fixed2(1, 1) * _MainTex_TexelSize.xy) * _Lapacian[8] * _Bright;
				
				

					//float4 result = tex2D(_MainTex, i.uv) *  _Lapacian[4] * _Bright;
			
					float4 result =newColor;
				return result;

			}
			ENDCG
		}
	}
}
