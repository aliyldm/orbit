package net.bigpoint.darkorbit.map.common.lensflares
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class LensFlaresLayer extends Sprite implements IUpdatable
   {
      
      private static const CHECK_PERIOD:int = 500;
      
      private var _provider:ILensFlaresProvider;
      
      private var _lensflares:Vector.<LensFlareView> = new Vector.<LensFlareView>();
      
      private var _lastOcclusionCheck:int = -1;
      
      private var _viewportRect:Rectangle = new Rectangle(0,0,1,1);
      
      private var _colliders:Vector.<ILensFlareCollider>;
      
      public function LensFlaresLayer(param1:Vector.<ILensFlareCollider>)
      {
         super();
         this._colliders = param1;
      }
      
      public function set provider(param1:ILensFlaresProvider) : void
      {
         this._provider = param1;
         this._lastOcclusionCheck = -1;
         this.lensFlares = this._provider ? this._provider.lensFlares : null;
      }
      
      private function set lensFlares(param1:Vector.<LensFlareVO>) : void
      {
         var _loc2_:LensFlareView = null;
         var _loc3_:LensFlareVO = null;
         while(this._lensflares.length > 0)
         {
            _loc2_ = this._lensflares.pop();
            _loc2_.cleanup();
            if(contains(_loc2_))
            {
               removeChild(_loc2_);
            }
         }
         if(param1)
         {
            for each(_loc3_ in param1)
            {
               _loc2_ = new LensFlareView(_loc3_,this._viewportRect);
               this._lensflares.push(_loc2_);
               addChild(_loc2_);
            }
            Settings.qualityBackground.changed.add(this.updateLensflareQuality);
            this.updateLensflareQuality();
         }
         else
         {
            Settings.qualityBackground.changed.remove(this.updateLensflareQuality);
         }
      }
      
      private function updateLensflareQuality() : void
      {
         visible = Settings.qualityBackground.high.value;
         this._lastOcclusionCheck = -1;
      }
      
      public function setViewportSize(param1:int, param2:int) : void
      {
         var _loc3_:LensFlareView = null;
         this._viewportRect.width = param1;
         this._viewportRect.height = param2;
         for each(_loc3_ in this._lensflares)
         {
            _loc3_.rect = this._viewportRect;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc4_:int = 0;
         if(!visible)
         {
            return;
         }
         var _loc2_:int = getTimer();
         var _loc3_:Boolean = this._lastOcclusionCheck < 0 || _loc2_ - this._lastOcclusionCheck >= CHECK_PERIOD;
         if(_loc3_)
         {
            this._lastOcclusionCheck = _loc2_;
         }
         if(this._provider)
         {
            _loc4_ = 0;
            while(_loc4_ < this._lensflares.length)
            {
               this._lensflares[_loc4_].updateLens(this._provider,this._colliders,_loc3_);
               _loc4_++;
            }
         }
      }
   }
}

