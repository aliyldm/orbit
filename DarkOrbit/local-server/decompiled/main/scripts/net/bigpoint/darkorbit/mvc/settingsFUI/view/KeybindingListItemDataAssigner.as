package net.bigpoint.darkorbit.mvc.settingsFUI.view
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.MovieClipLayer;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsKeyBindingItemVO;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   
   public class KeybindingListItemDataAssigner extends DefaultItemDataAssigner
   {
      
      private const TAB_COLOR_INACTIVE:int = 7320267;
      
      private const TAB_COLOR_ACTIVE:int = 15327936;
      
      protected var _actionLabel:Label;
      
      protected var _boundKeyLabel:Label;
      
      protected var _keybindingBackground:Coreponent;
      
      protected var _keybindingBackgroundClip:MovieClip;
      
      public function KeybindingListItemDataAssigner()
      {
         super();
         _mouseEnabled = true;
         _mouseChildrenEnabled = true;
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         initialize();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._actionLabel = getChildByName("actionLabel") as Label;
         this._boundKeyLabel = getChildByName("boundKey") as Label;
         this._keybindingBackground = getChildByName("boundKeyBg") as Coreponent;
         this._keybindingBackgroundClip = (this._keybindingBackground.skin.getSkinLayer("normal") as MovieClipLayer).getChildAt(0) as MovieClip;
         this._keybindingBackgroundClip.gotoAndStop(1);
         this._keybindingBackground.addChild(this._keybindingBackgroundClip);
         this._keybindingBackground.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverKeybinding);
         this._keybindingBackground.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutKeybinding);
         this._keybindingBackground.addEventListener(MouseEvent.CLICK,this.handleMouseClickedKeybinding);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.parent.addEventListener(SettingsWindowEvent.NOW_LISTENING_FOR_KEYBINDING,this.forceAbortKeyListening);
         this.parent.parent.addEventListener(SettingsWindowEvent.TAB_SWITCHED,this.forceAbortKeyListening);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
      }
      
      private function handleMouseOverKeybinding(param1:MouseEvent) : void
      {
         if(this._keybindingBackgroundClip.currentFrame == 1)
         {
            this._keybindingBackgroundClip.gotoAndStop(2);
         }
      }
      
      private function handleMouseOutKeybinding(param1:MouseEvent) : void
      {
         if(this._keybindingBackgroundClip.currentFrame == 2)
         {
            this._keybindingBackgroundClip.gotoAndStop(1);
         }
      }
      
      private function handleMouseClickedKeybinding(param1:MouseEvent) : void
      {
         this._keybindingBackgroundClip.gotoAndStop(3);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyPressed);
         this.dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.NOW_LISTENING_FOR_KEYBINDING,this.dataTyped));
      }
      
      private function handleKeyPressed(param1:KeyboardEvent) : void
      {
         this.dataTyped.boundKeyCode = param1.keyCode;
         this._boundKeyLabel.text = BPLocaleUtils.getKeyboardChar(this.dataTyped.boundKeyCode);
         this._keybindingBackgroundClip.gotoAndStop(1);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyPressed);
         this.dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.LISTED_KEYBINDING_CHANGED,this.dataTyped));
      }
      
      public function forceAbortKeyListening(param1:SettingsWindowEvent) : void
      {
         if(param1.target != this)
         {
            this._keybindingBackgroundClip.gotoAndStop(1);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyPressed);
         }
      }
      
      private function get dataTyped() : SettingsKeyBindingItemVO
      {
         return data as SettingsKeyBindingItemVO;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1 as SettingsKeyBindingItemVO;
         if(this.dataTyped)
         {
            this._actionLabel.text = BPLocale.getItem(this.dataTyped.actionKey);
            if(this.dataTyped.additionalActionNumber != SettingsKeyBindingItemVO.NO_ACTION_NUMBER)
            {
               this._actionLabel.text += " " + this.dataTyped.additionalActionNumber;
            }
            this._boundKeyLabel.text = BPLocaleUtils.getKeyboardChar(this.dataTyped.boundKeyCode);
         }
      }
   }
}

