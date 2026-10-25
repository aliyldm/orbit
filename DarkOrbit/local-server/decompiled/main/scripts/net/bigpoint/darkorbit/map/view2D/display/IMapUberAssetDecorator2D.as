package net.bigpoint.darkorbit.map.view2D.display
{
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   
   public interface IMapUberAssetDecorator2D
   {
      
      function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void;
   }
}

