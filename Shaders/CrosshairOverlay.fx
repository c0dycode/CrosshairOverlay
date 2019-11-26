/*------------------.
| :: Description :: |
'-------------------/

    Layer (version 1.1)

    Author: c0dycode
    License: MIT

    About:
    A simple crosshair/png overlay based on "Layer.fx". You can replace the "Crosshair.png" in the "Textures" folder with your own "Sticker".
    I've used/tested this with ReShade version 4.3.0 on Apex Legends.

    History:
    (*) Feature (+) Improvement (x) Bugfix (-) Information (!) Compatibility

    Version 1.1 by c0dycode
    * Added alpha/transparency option

    Version 1.0 by c0dycode
    * Added the ability to scale and move the layer around on XY axis
*/

#include "ReShade.fxh"
#include "ReShadeUI.fxh"

uniform float2 Layer_Pos < __UNIFORM_DRAG_FLOAT2
ui_label = "Layer Position";
ui_min = 0.0; ui_max = 1.0;
ui_step = (1.0 / 800.0);
> = float2(0.5, 0.5);

uniform float size <
ui_type = "drag";
ui_min = -4;
ui_max = 4;
ui_step = (1.0 / 800.0);
ui_label = "Crosshair Size";
ui_tooltip = "Size of the crosshair";
> = 0.5;

uniform float alpha <
ui_type = "drag";
ui_min = 0;
ui_max = 1;
ui_step = (1.0 / 255.0);
ui_label = "Crosshair Alpha";
ui_tooltip = "Alpha of the crosshair";
> = 1;

texture xhairTex <
    source = "crosshair.png";
> {
    Width = 1280; 
    Height = 720; 
    Format = RGBA8;
};
sampler	xhairSampler 	{ Texture = xhairTex; AddressU = BORDER; AddressV = BORDER; };

float4 PS_CrosshairOverlay(float4 pos : SV_Position, float2 texCoord : TexCoord) : SV_Target {
  const float4 backColor = tex2D(ReShade::BackBuffer, texCoord);
  const float2 pixelSize = 1.0 / (float2(800, 800) * size / ReShade::ScreenSize);
  const float4 layer     = tex2D(xhairSampler, texCoord * pixelSize + Layer_Pos * (1.0 - pixelSize));
  
  float4 color = lerp(backColor, layer, layer.a * alpha);
  color.a = 255;
  return color;
}

technique CrossHairOverlay {
  pass CrosshairOverlay {
    VertexShader = PostProcessVS;
    PixelShader  = PS_CrosshairOverlay;
  }
}