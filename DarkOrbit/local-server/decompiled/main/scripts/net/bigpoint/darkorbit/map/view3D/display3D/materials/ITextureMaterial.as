package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.textures.Texture2DBase;
   import org.osflash.signals.ISignal;
   
   public interface ITextureMaterial
   {
      
      function get supportedTextures() : Vector.<String>;
      
      function get supportedTexturesChanged() : ISignal;
      
      function setTexture(param1:String, param2:Texture2DBase) : void;
      
      function setShaderParams(param1:XML) : void;
      
      function dispose() : void;
   }
}

