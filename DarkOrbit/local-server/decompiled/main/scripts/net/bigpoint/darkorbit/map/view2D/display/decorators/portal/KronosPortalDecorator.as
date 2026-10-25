package net.bigpoint.darkorbit.map.view2D.display.decorators.portal
{
   import com.bigpoint.utils.PointLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.mvc.display.utils.DOBitmapAtlasResource;
   import net.bigpoint.darkorbit.mvc.display.utils.DOTexturesProxy;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.vo.AtlasResourceVO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.view.IAnimatedViewContainer;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class KronosPortalDecorator implements IUpdatable
   {
      
      private var _container:IDOSprite;
      
      private var _position:PointLite;
      
      private var _map:Bitmap;
      
      private var _mask:Bitmap;
      
      public function KronosPortalDecorator(param1:IAnimatedViewContainer, param2:PointLite)
      {
         super();
         this._position = param2;
         var _loc3_:AtlasResourceVO = param1.dto.searchForAtlasResourceVO("portal");
         var _loc4_:DOTexturesProxy = GameFacade.getInstance().retrieveProxy(DOTexturesProxy.NAME) as DOTexturesProxy;
         var _loc5_:DOBitmapAtlasResource = _loc4_.getTextureResource(_loc3_.textureResource,_loc3_.atlasResources);
         this.initMask(_loc5_);
         this.hScroll = 0.5;
         this.vScroll = 0.5;
         this._container = IDOSprite(param1.getViewById("map_preview"));
         this._container.addUntypedChild(this._map);
         this._container.addUntypedChild(this._mask);
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Ship = ScreenManager.getInstance().map.hero;
         if(_loc2_ != null && this._mask != null && Settings.autoQualityReduction.value < Settings.AQ_NO_PORTAL_TARGET_PREVIEW_LIMIT)
         {
            _loc3_ = ScreenManager.getScreenWidth() + 100;
            _loc4_ = ScreenManager.getScreenHeight() + 100;
            this.hScroll = Math.max(0,Math.min((_loc2_.x - (this._position.x - _loc3_ / 2)) / _loc3_,1));
            this.vScroll = Math.max(0,Math.min((_loc2_.y - (this._position.y - _loc4_ / 2)) / _loc4_,1));
         }
      }
      
      public function set hScroll(param1:Number) : void
      {
         this._map.x = -(this._map.width - this._mask.width) * param1;
      }
      
      public function initMask(param1:DOBitmapAtlasResource) : void
      {
         this._map = new Bitmap(param1.atlas.getTexture(param1.texture as BitmapData,"map_preview"));
         this._mask = new Bitmap(param1.atlas.getTexture(param1.texture as BitmapData,"map_mask"));
         this._map.mask = this._mask;
         this._map.cacheAsBitmap = this._mask.cacheAsBitmap = true;
      }
      
      public function set vScroll(param1:Number) : void
      {
         this._map.y = -(this._map.height - this._mask.height) * param1;
      }
   }
}

