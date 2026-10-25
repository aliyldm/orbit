package net.bigpoint.darkorbit.map.common.lensflares
{
   import com.bigpoint.utils.PointLite;
   
   public interface ILensFlaresProvider
   {
      
      function get lensFlares() : Vector.<LensFlareVO>;
      
      function calculateScreenPosition(param1:LensFlareVO, param2:PointLite) : void;
   }
}

