Shader "Mirror/Shrink"
{
	Properties{
		_MainTex("texture",2D) = "white"{}
		_CenterX("centerX",Range(0,1)) = 0.5
		_CenterY("centerY",Range(0,1)) = 0.5
		_Instensity("instence", Range(0,3)) = 0.3
	}
	SubShader{
		tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		Pass{
			CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag  
				#include "UnityCG.cginc" 

				float4 _Color;
				sampler2D _MainTex;
				float _CenterX;
				float _CenterY;
				float _Instensity;

				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;
				};

				float4 _MainTex_ST;
				v2f vert(appdata_base v) {
					v2f o;
					o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
					return o;
				};

				float newX = 0;
				float newY = 0;
				float _Radius;
				float theta = 0;
				half4 frag(v2f i) :COLOR
				{
					float tx = i.uv.x - _CenterX;
					float ty = i.uv.y - _CenterY;

					theta = atan2(ty, tx);
					float radius = sqrt(tx * tx + ty * ty);
					float newR = sqrt(radius) * _Instensity;

					newX = _CenterX + newR*cos(theta);
					newY = _CenterY + newR*sin(theta);
					
					newX = clamp(newX, 0, 1);
					newY = clamp(newY, 0, 1);

					float2 uv_earth = float2(newX,newY);
					half4 texcolor_earth = tex2D(_MainTex,uv_earth);

					return texcolor_earth;
				}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
