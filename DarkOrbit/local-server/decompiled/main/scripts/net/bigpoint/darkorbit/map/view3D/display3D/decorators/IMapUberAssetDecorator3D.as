package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   
   public interface IMapUberAssetDecorator3D
   {
      
      function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void;
      
      function decorate() : void;
   }
}

