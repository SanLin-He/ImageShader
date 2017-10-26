Shader "Mirror/Symmetry"
{
	//对称特效  
	Properties{
		_MainTex("texture",2D) = "white"{}
		_Axis_Y("axis_y", Range(0,1)) = 0.5
		_Axis_X("axis_X", Range(0,1)) = 0.5
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
				uniform float _Axis_Y;
				uniform float _Axis_X;

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
				half4 frag(v2f i) :COLOR
				{
					float uv_x;
					if (i.uv.x > _Axis_Y) {
						uv_x = 1 - i.uv.x;
					}
					else {
						uv_x = i.uv.x;
					}
					float uv_y;
					if (i.uv.y > _Axis_X) {
						uv_y = 1 - i.uv.y;
					}
					else {
						uv_y = i.uv.y;
					}

					float2 uv_earth = float2(uv_x,uv_y);
					half4 texcolor_earth = tex2D(_MainTex,uv_earth);

					return texcolor_earth;
				}
			ENDCG
			}
	}
	FallBack "Diffuse"
}
