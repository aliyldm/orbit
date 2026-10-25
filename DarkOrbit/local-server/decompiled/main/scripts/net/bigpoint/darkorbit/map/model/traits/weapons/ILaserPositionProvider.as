package net.bigpoint.darkorbit.map.model.traits.weapons
{
   import flash.geom.Vector3D;
   
   public interface ILaserPositionProvider
   {
      
      function getSalvos() : Vector.<Vector.<String>>;
      
      function getLaserCannonLocalPosition(param1:String, param2:Vector3D, param3:Number = NaN) : void;
   }
}

