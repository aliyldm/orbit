package net.bigpoint.darkorbit.map.hud.debug
{
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.ILayerChild;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   
   public class ShipDebugHUD extends AbstractHUDElement implements ILayerChild
   {
      
      private var _ship:Ship;
      
      private var _labelF:TextField;
      
      private var _icon:Bitmap;
      
      public function ShipDebugHUD(param1:IMapView, param2:MapObjectInfoTrait)
      {
         var _loc3_:Shape = null;
         super(param1,param2.owner.position);
         this._ship = param2.owner as Ship;
         if(this._ship)
         {
            this._labelF = new TextField();
            this._labelF.autoSize = TextFieldAutoSize.CENTER;
            this._labelF.multiline = true;
            this._labelF.wordWrap = true;
            this._labelF.width = 300;
            this._labelF.defaultTextFormat = new TextFormat(null,12,16777215);
            this._labelF.filters = [new GlowFilter(1,1,2,2,10,1)];
            this._labelF.x = 20.5;
            this._labelF.y = -160 - 20.5;
            addChild(this._labelF);
            _loc3_ = new Shape();
            _loc3_.graphics.beginFill(16777215,1);
            _loc3_.graphics.drawRect(-20.5,-20.5,41,41);
            _loc3_.graphics.endFill();
            _loc3_.y = -160;
            addChild(_loc3_);
            this._icon = new Bitmap();
            this._icon.y = -160 - 20.5;
            this._icon.x = -20.5;
            addChild(this._icon);
            this._ship.shipPatternChanged.add(this.update);
            this.update();
         }
      }
      
      public function get layer() : int
      {
         return 0;
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._ship)
         {
            this._ship.shipPatternChanged.remove(this.update);
         }
         super.disposeView(param1);
      }
      
      private function update() : void
      {
         var iconId:String = null;
         var finisher:SWFFinisher = null;
         var igc:InGameCatalog = InGameCatalog.instance;
         var details:Array = [];
         details.push("name lootID:" + igc.getShipNameFromLootId(this._ship.shipPattern.typeId));
         if(this._ship.shipPattern.npcId)
         {
            iconId = igc.getNpcIcon(this._ship.shipPattern.npcId) + "_icon.png";
            details.push("npc id[" + this._ship.shipPattern.npcId + "] name[" + igc.getNpcName(this._ship.shipPattern.npcId) + "]");
            details.push("icon [" + iconId + "]");
         }
         else if(this._ship.shipPattern.shipId)
         {
            iconId = igc.getShipIcon(this._ship.shipPattern.shipId) + "_icon.png";
            details.push("player ship id[" + this._ship.shipPattern.shipId + "] name[" + igc.getShipName(this._ship.shipPattern.shipId) + "]");
            details.push("icon [" + iconId + "]");
         }
         else
         {
            details.push("--");
         }
         this._labelF.text = details.join("\n");
         try
         {
            finisher = ResourceManager.fileCollection.getFinisher("icons") as SWFFinisher;
            this._icon.bitmapData = finisher.getEmbeddedBitmapData(iconId);
         }
         catch(e:Error)
         {
            _icon.bitmapData = null;
         }
      }
   }
}

