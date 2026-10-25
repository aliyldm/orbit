package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.StreunerTurretOpenEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   
   public class TurretDecorator2D implements IMapUberAssetDecorator2D
   {
      
      private var _viewOwner:UberAsset2D;
      
      public function TurretDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._viewOwner = param2;
         ScreenManager.getInstance().map.effects.addEffectOnce(new StreunerTurretOpenEffect(param1.owner));
      }
   }
}

