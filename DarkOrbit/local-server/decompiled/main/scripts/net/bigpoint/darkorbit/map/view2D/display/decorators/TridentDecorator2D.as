package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.debug.Trident2D;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   
   public class TridentDecorator2D implements IMapUberAssetDecorator2D
   {
      
      public function TridentDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         param2.addChild(new Trident2D());
      }
   }
}

