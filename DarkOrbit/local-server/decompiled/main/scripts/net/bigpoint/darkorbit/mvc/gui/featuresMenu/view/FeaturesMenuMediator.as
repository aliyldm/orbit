package net.bigpoint.darkorbit.mvc.gui.featuresMenu.view
{
   import com.bigpoint.utils.drag.DragEvent;
   import com.bigpoint.utils.ui.lists.layoutedList.LayoutedListDecorator;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.view.AbstractMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureBarVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureItemVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeatureBtn;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeaturesMenu;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class FeaturesMenuMediator extends AbstractMenuMediator
   {
      
      public static const NAME:String = "FeaturesMenuMediator";
      
      private var _featuresBtnsMap:Dictionary;
      
      private var _contactsUnreadCount:int;
      
      private var _chatUnreadCount:int;
      
      public function FeaturesMenuMediator(param1:FeaturesMenu, param2:SWFFinisher)
      {
         super(NAME,param1);
         _swfFinisher = param2;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [FeaturesMenuNotifications.DATA_READY,FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS,FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,GuiNotifications.MANAGE_MENUS_CONFIG_MODE,FeaturesMenuNotifications.HIGHLIGHT_ITEM,FeaturesMenuNotifications.STOP_HIGHLIGHT_ITEM,ContactsWindowNotifications.WHISPER_UNREAD_CHANGED,DOChatClientNotifications.UNREAD_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:HighlightItemVO = null;
         var _loc5_:HighlightItemVO = null;
         var _loc6_:Boolean = false;
         switch(param1.getName())
         {
            case FeaturesMenuNotifications.DATA_READY:
               this.initBarsMap();
               this._featuresBtnsMap = new Dictionary();
               this.initFeatureBar(this.view.gameFeatureBar,FeaturesMenuConstants.GAME_FEATURE_BAR);
               this.initFeatureBar(this.view.genericFeatureBar,FeaturesMenuConstants.GENERIC_FEATURE_BAR);
               sendNotification(FeaturesMenuNotifications.UPDATE_POSITION,GuiConstants.SET_MENUS_INIT_POSITION);
               this.updateBtnsSelections();
               this.syncContactsUnreadCount();
               this.applyContactsUnreadCount();
               this.syncChatUnreadCount();
               this.applyChatUnreadCount();
               break;
            case FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS:
               this.updateBtnsSelections();
               this.applyChatUnreadCount();
               break;
            case FeaturesMenuNotifications.TOGGLE_BTN_SELECTION:
               _loc2_ = param1.getType();
               _loc3_ = Boolean(param1.getBody());
               this.toggleBtnSelection(_loc2_,_loc3_);
               break;
            case FeaturesMenuNotifications.HIGHLIGHT_ITEM:
               _loc4_ = param1.getBody() as HighlightItemVO;
               this.highliteButton(_loc4_);
               break;
            case FeaturesMenuNotifications.STOP_HIGHLIGHT_ITEM:
               _loc5_ = param1.getBody() as HighlightItemVO;
               this.stopHighliteButton(_loc5_);
               break;
            case ContactsWindowNotifications.WHISPER_UNREAD_CHANGED:
               this._contactsUnreadCount = Math.max(0,int(param1.getBody()));
               this.applyContactsUnreadCount();
               break;
            case DOChatClientNotifications.UNREAD_CHANGED:
               this._chatUnreadCount = Math.max(0,int(param1.getBody()));
               this.applyChatUnreadCount();
               break;
            case GuiNotifications.MANAGE_MENUS_CONFIG_MODE:
               _loc6_ = Boolean(param1.getBody());
               manageConfigMode(_loc6_);
         }
      }
      
      private function stopHighliteButton(param1:HighlightItemVO) : void
      {
         var _loc2_:FeatureBtn = this.getGameFeatureBtnById(param1.itemId);
         _loc2_.stopHighlight();
      }
      
      private function highliteButton(param1:HighlightItemVO) : void
      {
         var _loc2_:FeatureBtn = this.getGameFeatureBtnById(param1.itemId);
         _loc2_.highlight(param1.highlightDuration);
      }
      
      override protected function initBarsMap() : void
      {
         _menuBars = new <DOAbstractLayoutedListBar>[this.view.gameFeatureBar,this.view.genericFeatureBar];
         _menuBarsMap = new Dictionary();
         _menuBarsMap[this.view.gameFeatureBar] = this.menuProxy.getMenuBarVOById(FeaturesMenuConstants.GAME_FEATURE_BAR);
         _menuBarsMap[this.view.genericFeatureBar] = this.menuProxy.getMenuBarVOById(FeaturesMenuConstants.GENERIC_FEATURE_BAR);
      }
      
      private function initFeatureBar(param1:DOAbstractLayoutedListBar, param2:String) : void
      {
         var _loc7_:int = 0;
         var _loc8_:FeatureBarVO = null;
         var _loc9_:FeatureItemVO = null;
         var _loc10_:FeatureBtn = null;
         var _loc3_:FeatureBarVO = this.menuProxy.getMenuBarById(param2) as FeatureBarVO;
         var _loc4_:Vector.<FeatureItemVO> = new Vector.<FeatureItemVO>();
         var _loc5_:int = 0;
         while(_loc5_ != _loc3_.featureItems.length)
         {
            _loc4_.push(_loc3_.featureItems[_loc5_]);
            _loc5_++;
         }
         if(param2 == FeaturesMenuConstants.GAME_FEATURE_BAR)
         {
            _loc8_ = this.menuProxy.getMenuBarById(FeaturesMenuConstants.GAME_NEW_FEATURE_BAR) as FeatureBarVO;
            _loc7_ = int(_loc8_.featureItems.length);
            _loc5_ = 0;
            while(_loc5_ != _loc7_)
            {
               _loc4_.push(_loc8_.featureItems[_loc5_]);
               _loc5_++;
            }
         }
         var _loc6_:Array = [];
         _loc7_ = int(_loc4_.length);
         _loc5_ = 0;
         while(_loc5_ != _loc7_)
         {
            _loc9_ = _loc4_[_loc5_];
            if(_loc9_.visible)
            {
               _loc10_ = new FeatureBtn(_swfFinisher,TextUtils.getTooltipText(_loc9_.tooltipKeyList),this.getIconBitmapData(_loc9_.id + GuiConstants.NORMAL_SUFFIX),this.getIconBitmapData(_loc9_.id + GuiConstants.HOVER_SUFFIX),this.getIconBitmapData(_loc9_.id + GuiConstants.SELECT_SUFFIX));
               _loc10_.barId = _loc9_.barId;
               this._featuresBtnsMap[_loc10_] = _loc9_;
               _loc6_.push(_loc10_);
            }
            _loc5_++;
         }
         param1.showItems(_loc6_,_loc7_,SlotAndItemBarElement.DEFAULT_SIZE,false,null,null,SlotAndItemBarElement.NEW_GAME_BTN_POS_Y);
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         this.view.addEventListener(FeatureBtn.FEATURE_BTN_CLICKED,this.featureBtnClickHandler);
         this.view.addEventListener(FeatureBtn.FEATURE_BTN_ROLLED_OVER,this.featureBtnRollHandler);
         this.view.addEventListener(FeatureBtn.FEATURE_BTN_ROLLED_OUT,this.featureBtnRollHandler);
         this.view.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.view.addEventListener(Event.ADDED,this.mouseDownHandler);
         this.view.addEventListener(LayoutedListDecorator.LAYOUT_CHANGE_COMPLETE,this.layoutChangeComplete);
      }
      
      private function featureBtnRollHandler(param1:Event) : void
      {
         var _loc2_:FeatureItemVO = this._featuresBtnsMap[param1.target] as FeatureItemVO;
         if(_loc2_.id == GuiConstants.HELP_WINDOW)
         {
            if(param1.type == FeatureBtn.FEATURE_BTN_ROLLED_OVER)
            {
               TooltipControl.getInstance().showAllStickyToolTips();
            }
            else if(param1.type == FeatureBtn.FEATURE_BTN_ROLLED_OUT)
            {
               TooltipControl.getInstance().hideAllStickyToolTips();
            }
         }
      }
      
      override protected function barDragOverHandler(param1:DragEvent) : void
      {
         super.barDragOverHandler(param1);
         sendNotification(FeaturesMenuNotifications.CHECK_BOUNDS_AND_SAVE_POS);
      }
      
      private function layoutChangeComplete(param1:Event) : void
      {
         sendNotification(FeaturesMenuNotifications.CHECK_BOUNDS_AND_SAVE_POS);
      }
      
      private function updateBtnsSelections() : void
      {
         var _loc1_:Object = null;
         var _loc2_:FeatureBtn = null;
         var _loc3_:FeatureItemVO = null;
         var _loc4_:SimpleWindow = null;
         for(_loc1_ in this._featuresBtnsMap)
         {
            _loc2_ = _loc1_ as FeatureBtn;
            _loc3_ = this._featuresBtnsMap[_loc2_] as FeatureItemVO;
            _loc4_ = guiManager.getWindow(_loc3_.id);
            if(Boolean(_loc3_.featureWindowVO) && Boolean(_loc4_))
            {
               _loc2_.selected = _loc3_.visible && _loc3_.featureWindowVO.maximized;
            }
         }
      }
      
      private function toggleBtnSelection(param1:String, param2:Boolean) : void
      {
         var _loc3_:FeatureBtn = this.getGameFeatureBtnById(param1);
         var _loc4_:FeatureItemVO = this._featuresBtnsMap[_loc3_] as FeatureItemVO;
         if((Boolean(_loc4_)) && Boolean(_loc4_.featureWindowVO))
         {
            _loc4_.featureWindowVO.maximized = param2;
         }
         if(_loc3_)
         {
            _loc3_.selected = param2;
         }
      }
      
      private function featureBtnClickHandler(param1:Event) : void
      {
         var _loc2_:FeatureBtn = param1.target as FeatureBtn;
         var _loc3_:FeatureItemVO = this._featuresBtnsMap[_loc2_] as FeatureItemVO;
         sendNotification(FeaturesMenuNotifications.ACTION_TRIGERRED,_loc2_,_loc3_.id);
      }
      
      public function getGameFeatureBtnById(param1:String) : FeatureBtn
      {
         var _loc2_:Object = null;
         var _loc3_:FeatureItemVO = null;
         for(_loc2_ in this._featuresBtnsMap)
         {
            _loc3_ = this._featuresBtnsMap[_loc2_] as FeatureItemVO;
            if(_loc3_.id == param1)
            {
               return _loc2_ as FeatureBtn;
            }
         }
         return null;
      }
      
      private function applyContactsUnreadCount() : void
      {
         if(!this._featuresBtnsMap)
         {
            return;
         }
         var _loc1_:FeatureBtn = this.getGameFeatureBtnById(GuiConstants.CONTACTLIST_WINDOW);
         if(_loc1_)
         {
            _loc1_.setNotificationCount(this._contactsUnreadCount);
         }
      }
      
      private function syncContactsUnreadCount() : void
      {
         var _loc1_:ContactsWindowProxy = facade.retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy;
         if(_loc1_)
         {
            this._contactsUnreadCount = _loc1_.unreadWhisperUserCount;
         }
      }
      
      private function syncChatUnreadCount() : void
      {
         var _loc1_:DOChatProxy = facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         if(Boolean(_loc1_) && Boolean(_loc1_.chatModel))
         {
            this._chatUnreadCount = _loc1_.chatModel.hasUnreadPublicChannelMessages ? 1 : 0;
         }
      }
      
      private function applyChatUnreadCount() : void
      {
         var _loc2_:SimpleWindow = null;
         if(!this._featuresBtnsMap)
         {
            return;
         }
         var _loc1_:FeatureBtn = this.getGameFeatureBtnById(GuiConstants.CHAT_WINDOW);
         if(_loc1_)
         {
            _loc2_ = guiManager.getWindow(GuiConstants.CHAT_WINDOW);
            _loc1_.setNotificationCount(this._chatUnreadCount > 0 && (!_loc2_ || !_loc2_.maximized) ? 1 : 0,false);
         }
      }
      
      private function mouseDownHandler(param1:Event) : void
      {
         param1.stopPropagation();
      }
      
      private function getIconBitmapData(param1:String) : BitmapData
      {
         return assetsProxy.getBitmapDataFromAtlas(param1,FeaturesMenuConstants.ICONS_BITMAP_ATLAS);
      }
      
      protected function get menuProxy() : FeaturesMenuProxy
      {
         return facade.retrieveProxy(FeaturesMenuProxy.NAME) as FeaturesMenuProxy;
      }
      
      public function get view() : FeaturesMenu
      {
         return viewComponent as FeaturesMenu;
      }
   }
}

