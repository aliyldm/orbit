package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.fui.builder.repository.FilterRepository;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.SpaceMapConfig;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.SpaceMapView;
   
   public class SpaceMapToolTipGateIcon extends Sprite
   {
      
      public static const LINK:String = "mapIcon_marker";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const TOP:String = "top";
      
      public static const BOTTOM:String = "bottom";
      
      public static const GLOW_FILTER_KEY:String = "color0x000000blurx2blury2strength10quality2";
      
      private var _labelPositions:Object;
      
      private var _labelAutoSizes:Object;
      
      private var _gateLabel:TextField;
      
      private var _bitmapIcon:Bitmap;
      
      public function SpaceMapToolTipGateIcon()
      {
         super();
         this.initIcon();
         this.initLabel();
         this.initLabelPositions();
      }
      
      public function get bitmapIcon() : Bitmap
      {
         return this._bitmapIcon;
      }
      
      public function setGateLabelText(param1:int) : void
      {
         var _loc2_:int = SpaceMapConfig.gateLeadsToMapId(param1);
         this._gateLabel.text = Map.getMapName(_loc2_);
         var _loc3_:String = SpaceMapConfig.gateLabelPosition(param1);
         var _loc4_:Point = Point(this._labelPositions[_loc3_]);
         this._gateLabel.autoSize = this._labelAutoSizes[_loc3_];
         this._gateLabel.x = _loc3_ == LEFT ? _loc4_.x - this._gateLabel.textWidth - 4 : _loc4_.x;
         this._gateLabel.y = _loc4_.y;
         this._gateLabel.visible = true;
      }
      
      protected function initIcon() : void
      {
         this._bitmapIcon = new Bitmap(SWFFinisher(ResourceManager.fileCollection.getFinisher(SpaceMapView.SPACE_MAP_LIBRARY_ID)).getEmbeddedBitmapData(LINK));
         this._bitmapIcon.smoothing = true;
         addChild(this._bitmapIcon);
      }
      
      protected function initLabel() : void
      {
         this._gateLabel = new TextField();
         this._gateLabel.defaultTextFormat = Styles.spaceMapFontFmt;
         this._gateLabel.selectable = false;
         this._gateLabel.width = Styles.spaceMapFontWidth;
         this._gateLabel.height = Styles.spaceMapFontHeight;
         var _loc1_:GlowFilter = FilterRepository.getInstance().getByKey(GLOW_FILTER_KEY) as GlowFilter;
         this._gateLabel.filters = [_loc1_];
         this._gateLabel.visible = false;
         addChild(this._gateLabel);
      }
      
      protected function initLabelPositions() : void
      {
         this._labelPositions = {};
         this._labelPositions[LEFT] = new Point(0,0);
         this._labelPositions[RIGHT] = new Point(this._bitmapIcon.width,0);
         this._labelPositions[TOP] = new Point(-(this._gateLabel.width >> 2) + 1,-this._gateLabel.height + 2);
         this._labelPositions[BOTTOM] = new Point(-(this._gateLabel.width >> 2) + 1,this._gateLabel.height - 2);
         this._labelAutoSizes = {};
         this._labelAutoSizes[LEFT] = TextFieldAutoSize.RIGHT;
         this._labelAutoSizes[RIGHT] = TextFieldAutoSize.LEFT;
         this._labelAutoSizes[TOP] = this._labelAutoSizes[BOTTOM] = TextFieldAutoSize.CENTER;
      }
   }
}

