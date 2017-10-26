//明度、饱和度、对比度调节
Shader "Mirro/ColorBSC"
{
	
		//属性块，shader用到的属性，可以直接在Inspector面板调整  
		Properties
		{
			_MainTex("Albedo (RGB)", 2D) = "white" {}
			_Brightness("Brightness", Float) = 1
			_Saturation("Saturation", Float) = 1
			_Contrast("Contrast", Float) = 1
		}

		//每个shader都有Subshaer，各个subshaer之间是平行关系，只可能运行一个subshader，主要针对不同硬件  
		SubShader
		{
		
		Pass
		{
			
			ZTest Always Cull Off ZWrite Off
			CGPROGRAM
			//在Properties中的内容只是给Inspector面板使用，真正声明在此处，注意与上面一致性  
		sampler2D _MainTex;
		half _Brightness;
		half _Saturation;
		half _Contrast;

		//vert和frag函数  
		#pragma vertex vert  
		#pragma fragment frag  
		#include "Lighting.cginc"  

		
		struct v2f
		{
			float4 pos : SV_POSITION; //顶点位置  
			half2  uv : TEXCOORD0;    //UV坐标  
		};

	
		v2f vert(appdata_img v)
		{
			v2f o;
			//从自身空间转向投影空间  
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			//uv坐标赋值给output  
			o.uv = v.texcoord;
			return o;
		}

		
		fixed4 frag(v2f i) : SV_Target
		{
			//从_MainTex中根据uv坐标进行采样  
			fixed4 renderTex = tex2D(_MainTex, i.uv);
			
			//brigtness亮度直接乘以一个系数，也就是RGB整体缩放，调整亮度  
			fixed3 finalColor = renderTex * _Brightness;
			
			//saturation饱和度：首先根据公式计算同等亮度情况下饱和度最低的值：  
			fixed gray = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
			fixed3 grayColor = fixed3(gray.xxx);
			//根据Saturation在饱和度最低的图像和原图之间差值  
			finalColor = lerp(grayColor, finalColor, _Saturation);
			
			//contrast对比度：首先计算对比度最低的值  
			fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
			//根据Contrast在对比度最低的图像和原图之间差值  
			finalColor = lerp(avgColor, finalColor, _Contrast);
			
			//返回结果，alpha通道不变  
			return fixed4(finalColor, renderTex.a);
		}
			ENDCG
		}
		}
			//防止shader失效的保障措施  
			FallBack Off
	}

