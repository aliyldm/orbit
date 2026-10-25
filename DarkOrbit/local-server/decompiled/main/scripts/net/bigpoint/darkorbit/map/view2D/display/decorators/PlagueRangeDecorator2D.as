package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberMapAssetView2D;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.view.IAnimatedViewContainer;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class PlagueRangeDecorator2D implements IMapUberAssetDecorator2D
   {
      
      private var _container:IAnimatedViewContainer;
      
      private var _trait:UberDisplayTrait;
      
      private var _viewOwner:UberAsset2D;
      
      public function PlagueRangeDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._viewOwner = param2;
         this._viewOwner.disposeFunction = this.disposeView;
         this._container = (this._viewOwner.getViewElement("view") as UberMapAssetView2D).view;
      }
      
      private function disposeView() : void
      {
         this._container.stopTween("default");
         this._container.startTween("close");
         setTimeout(this.cleanup,700);
         setTimeout(ScreenManager.getInstance().map.effects.addEffect,200,new PyroEffect(this._trait.owner.x,this._trait.owner.y,this._trait.owner.z,PatternManager.getPyroPattern(ExplosionPattern.TYPE_MINE_EXPLOSION,3)));
      }
      
      private function cleanup() : void
      {
         this._viewOwner.disposeFunction = null;
         this._viewOwner.disposeView();
      }
   }
}

