package net.bigpoint.darkorbit.mvc.sectorControl.view.components
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SectorControlProgressBar extends Sprite
   {
      
      private const barHeight:int = 8;
      
      public var bar:Shape = new Shape();
      
      public var background:Shape = new Shape();
      
      public var text:TextField = new TextField();
      
      public function SectorControlProgressBar(param1:Boolean = false)
      {
         super();
         this.bar.cacheAsBitmap = true;
         this.background.cacheAsBitmap = true;
         this.changeBarFactionTo(FactionModule.FACTION_NONE);
         this.changeBorderFactionTo(FactionModule.FACTION_NONE);
         this.text.embedFonts = Styles.simpleEmbed;
         this.text.defaultTextFormat = Styles.sectorControlProgressBarDirectionFmt;
         this.text.autoSize = TextFieldAutoSize.CENTER;
         this.addChild(this.background);
         this.addChild(this.text);
         this.addChild(this.bar);
         this.visible = param1;
         this.alpha = 0.5;
         this.mouseEnabled = false;
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.handleStageResize();
         this.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         this.stage.addEventListener(Event.RESIZE,this.handleStageResize);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
      }
      
      private function handleStageResize(param1:Event = null) : void
      {
         if(!stage)
         {
            return;
         }
         this.y = stage.stageHeight / 8;
         this.x = stage.stageWidth * 0.5 - this.width * 0.5;
         this.text.x = 0.5 * this.background.width;
         this.text.y = this.background.height;
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         if(stage)
         {
            this.stage.removeEventListener(Event.RESIZE,this.handleStageResize);
         }
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
      }
      
      public function changeBarFactionTo(param1:int) : void
      {
         this.bar.graphics.clear();
         this.bar.graphics.beginFill(InGameCatalog.getInstance().factions_colours[param1],0.5);
         this.bar.graphics.drawRect(0,0,ScreenManager.getHalfScreenWidth(),1);
         this.bar.graphics.drawRect(0,1,1,this.barHeight - 2);
         this.bar.graphics.drawRect(ScreenManager.getHalfScreenWidth() - 1,1,1,this.barHeight - 2);
         this.bar.graphics.drawRect(0,this.barHeight - 1,ScreenManager.getHalfScreenWidth(),1);
         this.bar.graphics.endFill();
         this.bar.graphics.beginFill(InGameCatalog.getInstance().factions_colours[param1],1);
         this.bar.graphics.drawRect(1,1,ScreenManager.getHalfScreenWidth() - 2,this.barHeight - 2);
         this.bar.graphics.endFill();
         this.handleStageResize();
      }
      
      public function changeBorderFactionTo(param1:int) : void
      {
         var _loc2_:int = 8355711;
         var _loc3_:int = int(InGameCatalog.getInstance().factions_colours[param1]);
         if(param1 == FactionModule.FACTION_NONE)
         {
            _loc3_ = _loc2_;
         }
         this.background.graphics.clear();
         this.background.graphics.beginFill(_loc2_,0.5);
         this.background.graphics.drawRect(0,0,ScreenManager.getHalfScreenWidth(),1);
         this.background.graphics.drawRect(0,1,1,this.barHeight - 2);
         this.background.graphics.drawRect(ScreenManager.getHalfScreenWidth() - 1,1,1,this.barHeight - 2);
         this.background.graphics.drawRect(0,this.barHeight - 1,ScreenManager.getHalfScreenWidth(),1);
         this.background.graphics.endFill();
         this.background.graphics.beginFill(_loc2_,1);
         this.background.graphics.drawRect(1,1,ScreenManager.getHalfScreenWidth() - 2,this.barHeight - 2);
         this.background.graphics.endFill();
         this.background.graphics.lineStyle(1,_loc3_);
         this.background.graphics.moveTo(-2,-2);
         this.background.graphics.lineTo(ScreenManager.getHalfScreenWidth() + 2,-2);
         this.background.graphics.lineTo(ScreenManager.getHalfScreenWidth() + 2,this.barHeight + 2);
         this.background.graphics.lineTo(-2,this.barHeight + 2);
         this.background.graphics.lineTo(-2,-2);
         this.handleStageResize();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(super.visible != param1)
         {
            super.visible = param1;
            if(visible)
            {
               ScreenManager.getInstance().getGUILayer0().addChild(this);
            }
            else
            {
               MovieClipUtils.removeDisplayObject(this);
            }
         }
      }
   }
}

