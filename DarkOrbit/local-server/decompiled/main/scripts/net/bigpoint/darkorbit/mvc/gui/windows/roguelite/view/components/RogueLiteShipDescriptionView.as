package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.video.VideoPlayer;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteShipVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RogueLiteShipDescriptionView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _shipVO:RogueLiteShipVO;
      
      public function RogueLiteShipDescriptionView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
      }
      
      private function get descriptionText() : Label
      {
         return this._cache.selectComponent("describe_ship.description_body.ship_description") as Label;
      }
      
      private function get nameText() : Label
      {
         return this._cache.selectComponent("describe_ship.description_body.ship_name") as Label;
      }
      
      private function get shipVideoPlayer() : VideoPlayer
      {
         return this._cache.selectComponent("describe_ship.description_body.ship_video") as VideoPlayer;
      }
      
      private function get shipDisplay() : Coreponent
      {
         return this._cache.selectComponent("describe_ship.description_body.ship_pic") as Coreponent;
      }
      
      public function set shipVO(param1:RogueLiteShipVO) : void
      {
         this._shipVO = param1;
         this.nameText.text = param1.shipVO.fullname;
         this.descriptionText.text = param1.shipVO.descriptionName;
         this.displayShip(param1.shipVO);
      }
      
      private function displayShip(param1:ItemVO) : void
      {
         var _loc3_:String = null;
         var _loc4_:Coreponent = null;
         var _loc2_:VideoPlayer = this.shipVideoPlayer;
         if(_loc2_)
         {
            _loc3_ = ItemsDataUtility.getVideoURLbyItem(param1.item);
            _loc2_.playURL(_loc3_);
         }
         else
         {
            _loc4_ = this.shipDisplay;
            if(_loc4_)
            {
               _loc4_.loadResource(this._shipVO.shipVO.getLoot100x100(Hero.factionName),this.handleShipSpriteLoaded,this.handleShipSpriteLoadError,AssetsProxy.ITEMS);
            }
         }
      }
      
      private function handleShipSpriteLoaded(param1:ImageFinisher) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.shipDisplay);
         this.shipDisplay.addChild(new Bitmap(param1.getBitmap().bitmapData));
         this.shipDisplay.visible = true;
      }
      
      private function handleShipSpriteLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.shipDisplay);
      }
   }
}

