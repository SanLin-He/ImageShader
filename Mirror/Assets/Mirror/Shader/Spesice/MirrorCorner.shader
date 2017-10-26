// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
//图片圆角
Shader "Mirror/RoundCorner"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		
		//边角半径
		_corner("cornerRadius",Range(0,0.25)) = 0.08
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
			fixed _percent;
			fixed _corner;
			float4 _MainTex_ST;
	
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				//o.color = v.color;
				return o;
			}
				
			fixed4 frag (v2f IN) : COLOR
			{
				fixed4 col = tex2D(_MainTex, IN.texcoord) ;
				
				// 计算圆角，巧妙的算法
				//图片中心的uv距离
				float2 uv2center = IN.texcoord.xy - float2(0.5,0.5);
				
				//保留半径
				float centerDist = 0.5 - _corner;
				
				//如果像素离中心的uv距离大于保留半径，则丢弃
				float dropx = step(centerDist, abs(uv2center.x));
				float dropy = step(centerDist, abs(uv2center.y));

				float rx = fmod(uv2center.x, centerDist);
				float ry = fmod(uv2center.y, centerDist);
				//如果预留的大于要剪切的，则丢弃
				float dropr = step(_corner, length(half2(rx,ry)));
				float alpha = 1 - dropx*dropy*dropr;//dropx保留x两端去掉coner长度的；dropy保留y两端去掉conner长度的；dropr保留剩余四个角的圆弧的
					
				col.a *= alpha;
				return col;
			}
			ENDCG
		}
	}


}
