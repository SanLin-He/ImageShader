Shader "Mirror/BlowUp"
{

	Properties{
		_MainTex("texture",2D) = "white"{}
		_Radius("radius",Range(0,0.5)) = 0.2
		_CenterX("centerX",Range(0,1)) = 0.5
		_CenterY("centerY",Range(0,1)) = 0.5
		_Instensity("instensity", Range(-10,10)) = 0.001
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
			uniform float _Instensity;
			
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
			
			uniform float _Radius;
			half4 frag(v2f i) :COLOR{
				
				float2 c = float2(_CenterX, _CenterY);
				float tx = i.uv.x - _CenterX;
				float ty = i.uv.y - _CenterY;

				float distan = tx*tx + ty*ty;
				//变形系数
				float p = sqrt(distan) / _Radius;
				//边沿处理系数  
				float discardFactor = clamp(_Radius - sqrt(distan), 0, 1) / _Radius;

				float2 newuv = i.uv + (( i.uv - c) * p + c) *_Instensity  * discardFactor;

				half4 texcolor_earth = tex2D(_MainTex, newuv);
				return texcolor_earth;
			}
				ENDCG
		}
	}
	FallBack "Diffuse"
}
