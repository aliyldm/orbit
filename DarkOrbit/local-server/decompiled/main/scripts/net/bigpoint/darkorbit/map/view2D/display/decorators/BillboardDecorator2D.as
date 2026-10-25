package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   
   public class BillboardDecorator2D implements IMapUberAssetDecorator2D, IUpdatable, IDisposable
   {
      
      private var _oscillationDuration:Number;
      
      private var _oscillationAmplitude:Number;
      
      private var _viewOwner:UberAsset2D;
      
      private var _trait:UberDisplayTrait;
      
      private var _data:Object;
      
      public function BillboardDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._trait = param1;
         this._viewOwner = param2;
         this._data = param3;
         this._viewOwner.alpha = 0;
         this._oscillationDuration = Number(param3.xml.@oscillationDuration) || 0;
         this._oscillationAmplitude = Number(param3.xml.@oscillationAmplitude) || 0;
         this.fadeIn();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this);
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(Boolean(this._oscillationDuration) && Boolean(this._oscillationAmplitude))
         {
            _loc2_ = new Date().getTime() / 1000 / this._oscillationDuration;
            _loc2_ *= Math.PI << 1;
            this._viewOwner.y = this._trait.owner.position.y + Math.sin(_loc2_) * this._oscillationAmplitude;
         }
      }
      
      private function createPartnerLogo(param1:ImageFinisher) : void
      {
         var _loc3_:Bitmap = null;
         var _loc2_:Bitmap = param1.getBitmap();
         if(_loc2_)
         {
            _loc3_ = new Bitmap(_loc2_.bitmapData.clone());
            _loc3_.x = int(this._data.xml.@advertX) || 0;
            _loc3_.y = int(this._data.xml.@advertY) || 0;
            this._viewOwner.addChild(_loc3_);
         }
         this.fadeIn();
      }
      
      private function fadeIn() : void
      {
         TweenMax.to(this._viewOwner,0.85,{"alpha":1});
      }
   }
}

