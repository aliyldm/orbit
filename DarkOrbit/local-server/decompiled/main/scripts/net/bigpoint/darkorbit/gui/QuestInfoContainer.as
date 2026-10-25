package net.bigpoint.darkorbit.gui
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.Interference;
   import net.bigpoint.darkorbit.gui.elements.TextAreaElement;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class QuestInfoContainer extends SimpleContainer
   {
      
      private var _height:int;
      
      private var _interference:Interference;
      
      private var _quest:Quest;
      
      private var _textArea:TextAreaElement;
      
      private var _placeHolder:DisplayObjectContainer;
      
      private var _questGiverPortrait:DisplayObject;
      
      private var _portraitResKey:String;
      
      public function QuestInfoContainer(param1:GuiManager)
      {
         super(param1,SimpleContainer.CLASS_QUEST_INFO);
         this._textArea = new TextAreaElement(200,50,TextFormatAlign.LEFT);
         this._textArea.textArea.editable = false;
         this._textArea.textArea.focusEnabled = false;
         this._placeHolder = new Sprite();
         this.addElement(this._placeHolder);
         this.addElement(this._textArea,SimpleContainer.ALIGN_HORIZONTAL);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedFromStage);
      }
      
      private function handleAddedFromStage(param1:Event) : void
      {
         InGameCatalog.getInstance().questgiverPortraitsChanged.add(this.updateQuestGiver);
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         InGameCatalog.getInstance().questgiverPortraitsChanged.remove(this.updateQuestGiver);
      }
      
      public function set quest(param1:Quest) : void
      {
         if(!this._quest || param1.id != this._quest.id)
         {
            this._quest = param1;
            this.updateQuestGiver();
            this.update();
         }
      }
      
      private function updateQuestGiver() : void
      {
         var _loc2_:MovieClip = null;
         if(this._quest == null)
         {
            return;
         }
         var _loc1_:String = this._quest.portraitId ? "questfm_" + this._quest.portraitId : InGameCatalog.instance.getQuestfmPortraitResKey(this._quest.id);
         if(this._portraitResKey == _loc1_)
         {
            return;
         }
         _loc2_ = ResourceManager.getMovieClip("questWin","questfm_portrait");
         if(!_loc2_)
         {
            return;
         }
         this._portraitResKey = _loc1_;
         this._height = _loc2_.height;
         this._interference = new Interference(_loc2_.width,_loc2_.height);
         this._interference.fadeOut = false;
         this._interference.alpha = 0.1;
         this._interference.playSound = false;
         this._interference.start();
         MovieClipUtils.cleanupDisplayObjectContainer(this._placeHolder);
         this._placeHolder.addChild(_loc2_);
         this._textArea.x = this._placeHolder.x + this._placeHolder.width;
         this._textArea.y = this._placeHolder.y;
         this._textArea.textArea.height = this._height;
         this._questGiverPortrait = ResourceManager.getDisplayObject("questWin",this._portraitResKey);
         if(this._questGiverPortrait)
         {
            this._questGiverPortrait.scrollRect = new Rectangle(0,0,_loc2_.width,_loc2_.height);
            _loc2_.content.addChild(this._questGiverPortrait);
         }
         _loc2_.content.addChild(this._interference);
      }
      
      private function update() : void
      {
         this._textArea.textArea.text = this._quest.description;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(Boolean(this._interference) && param1 != visible)
         {
            if(param1)
            {
               ScreenManager.addObserver(this._interference);
            }
            else
            {
               ScreenManager.removeObserver(this._interference);
            }
         }
         if(param1 && this._questGiverPortrait is MovieClip)
         {
            MovieClip(this._questGiverPortrait).gotoAndPlay(1);
         }
         super.visible = param1;
      }
   }
}

