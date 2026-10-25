package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import flash.geom.ColorTransform;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.env.collectable.Box;
   import net.bigpoint.darkorbit.map.model.env.collectable.Collectable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class CollectableDecorator2D implements IMapUberAssetDecorator2D, IDisposable
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _collectable:Collectable;
      
      private var _viewOwner:UberAsset2D;
      
      public function CollectableDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._trait = param1;
         this._viewOwner = param2;
         this._viewOwner.disposeFunction = this.disposeViewOwner;
         this._collectable = param1.owner as Collectable;
         this._collectable.collected.add(this.handleCollected);
         this._viewOwner.transform.colorTransform = new ColorTransform(1.1 - Math.random() * 0.2,1.1 - Math.random() * 0.2,1.1 - Math.random() * 0.2,1,Math.random() * 10 - 5,Math.random() * 10 - 5,Math.random() * 10 - 5,0);
         this._viewOwner.alpha = 0;
         if(this._collectable is Box && this._collectable.hash.length == 5)
         {
            return;
         }
         TweenLite.to(this._viewOwner,0.2,{
            "alpha":1,
            "ease":Quad.easeOut
         });
         if(this._collectable is Box && this._collectable.fresh && Settings.qualityCollectable.value > Settings.QUALITY_LOW)
         {
            this._viewOwner.y = this._collectable.y - 100;
            TweenLite.to(this._viewOwner,0.3,{
               "y":this._collectable.y,
               "ease":Quad.easeInOut
            });
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._collectable.collected.remove(this.handleCollected);
      }
      
      private function disposeViewOwner() : void
      {
         if(!this._collectable.isCollected)
         {
            TweenLite.to(this._viewOwner,0.4,{
               "alpha":0,
               "ease":Quad.easeIn,
               "onComplete":this.internalSelfRemove
            });
         }
      }
      
      private function handleCollected() : void
      {
         TweenLite.to(this._viewOwner,0.5,{
            "delay":0.3,
            "alpha":0,
            "y":"-50",
            "ease":Quad.easeIn,
            "onComplete":this.internalSelfRemove
         });
      }
      
      private function internalSelfRemove() : void
      {
         TweenLite.killTweensOf(this._viewOwner);
         if(this._viewOwner.parent)
         {
            this._viewOwner.parent.removeChild(this._viewOwner);
         }
         this._collectable.collected.remove(this.handleCollected);
         this._collectable = null;
         this._viewOwner.disposeFunction = null;
      }
   }
}

