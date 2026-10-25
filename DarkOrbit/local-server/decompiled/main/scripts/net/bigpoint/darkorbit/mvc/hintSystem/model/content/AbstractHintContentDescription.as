package net.bigpoint.darkorbit.mvc.hintSystem.model.content
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.fui.builder.xml.factories.TransitionEffectFactory;
   import net.bigpoint.darkorbit.fui.components.core.transitions.ITransitionEffect;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemContentVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemPlaylistItemVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemPlaylistVO;
   
   public class AbstractHintContentDescription implements IHintSystemContentDescription
   {
      
      public static const VIEWTEMPLATE_TYPE_DEFAULT:String = "default";
      
      public static const VIEWTEMPLATE_TYPE_PAYMENTLINK:String = "type.paymentLink";
      
      private static const ATTR_RPEAT:String = "repeat";
      
      private static const ATTR_RESKEY:String = "resKey";
      
      private static const ATTR_FADETIME:String = "fadeTime";
      
      private static const ATTR_EFFECT:String = "effect";
      
      private static const ATTR_DURATION:String = "duration";
      
      protected static var NOT_DEFINED:String = "Key value wasn´t specified yet.";
      
      protected var SORT_ORDER:uint = 100;
      
      protected var _id:uint;
      
      protected var _loaded:Boolean = false;
      
      protected var _viewStructure:XML;
      
      protected var _playlistNode:XML;
      
      protected var _content:HintSystemContentVO;
      
      protected var _contentName:String;
      
      protected var _wasOpenedFromWhom:Boolean;
      
      protected var _closeHintWindowOnMapJump:Boolean = true;
      
      protected var _title:String = NOT_DEFINED;
      
      protected var _message:String = NOT_DEFINED;
      
      public function AbstractHintContentDescription(param1:String)
      {
         super();
         this._contentName = param1;
      }
      
      public function get content() : HintSystemContentVO
      {
         return null;
      }
      
      protected function createContentFactionDependingVO() : HintSystemContentVO
      {
         var _loc1_:HintSystemContentVO = null;
         if(this._content == null)
         {
            _loc1_ = new HintSystemContentVO();
            _loc1_.title = BPLocale.getItem(this._title);
            _loc1_.message = this.getFactionRelatedMessageText(this._message);
            _loc1_.viewState = HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN;
            _loc1_.playlistVO = this.getParsedPlaylist();
            this._content = _loc1_;
         }
         return this._content;
      }
      
      protected function createContentVO() : HintSystemContentVO
      {
         var _loc1_:HintSystemContentVO = null;
         if(this._content == null)
         {
            _loc1_ = new HintSystemContentVO();
            _loc1_.title = BPLocale.getItem(this._title);
            _loc1_.message = BPLocale.getItem(this._message);
            _loc1_.viewState = HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN;
            _loc1_.playlistVO = this.getParsedPlaylist();
            this._content = _loc1_;
         }
         return this._content;
      }
      
      public function set id(param1:uint) : void
      {
         this._id = param1;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      protected function getParsedPlaylist() : HintSystemPlaylistVO
      {
         var _loc3_:XML = null;
         var _loc4_:Boolean = false;
         var _loc5_:HintSystemPlaylistVO = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:ITransitionEffect = null;
         var _loc11_:HintSystemPlaylistItemVO = null;
         if(this._playlistNode == null)
         {
            return null;
         }
         var _loc1_:Vector.<HintSystemPlaylistItemVO> = new Vector.<HintSystemPlaylistItemVO>();
         var _loc2_:XMLList = this._playlistNode..item;
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = _loc3_.attribute(ATTR_EFFECT);
            _loc7_ = _loc3_.attribute(ATTR_RESKEY);
            _loc8_ = Number(_loc3_.attribute(ATTR_FADETIME));
            _loc9_ = uint(_loc3_.attribute(ATTR_DURATION));
            _loc10_ = TransitionEffectFactory.create(_loc6_);
            _loc10_.fadeInTime = _loc8_;
            _loc10_.fadeOutTime = _loc8_;
            _loc11_ = new HintSystemPlaylistItemVO(_loc7_,_loc10_,_loc9_);
            _loc1_.push(_loc11_);
         }
         _loc4_ = ParserUtility.parseBooleanFromXmlAtribute(this._playlistNode.attribute(ATTR_RPEAT));
         return new HintSystemPlaylistVO(_loc1_,_loc4_);
      }
      
      public function set playistAsXML(param1:XML) : void
      {
         this._playlistNode = param1;
         this.content.playlistVO = this.getParsedPlaylist();
      }
      
      public function get playistAsXML() : XML
      {
         return this._playlistNode;
      }
      
      public function set viewStructureAsXML(param1:XML) : void
      {
         this._viewStructure = param1;
      }
      
      public function get viewStructureAsXML() : XML
      {
         return this._viewStructure;
      }
      
      public function getViewStructureResKey(param1:String = "default") : String
      {
         throw new Error("You have to specifiy a reskey for the content you like to visualize.");
      }
      
      public function isViewStructureLoaded() : Boolean
      {
         return this._loaded;
      }
      
      public function set viewStructureLoadStatus(param1:Boolean) : void
      {
         this._loaded = param1;
      }
      
      public function get sortOrder() : int
      {
         throw new Error("You have to implement the sortOder getter in your subclass.");
      }
      
      public function set wasOpenedFromArchive(param1:Boolean) : void
      {
         this._wasOpenedFromWhom = param1;
      }
      
      public function get wasOpenedFromArchive() : Boolean
      {
         return this._wasOpenedFromWhom;
      }
      
      public function getFactionRelatedMessageText(param1:String) : String
      {
         param1 += "_" + String(InGameCatalog.instance.factions_names[Hero.factionID.value]).toLowerCase();
         var _loc2_:String = BPLocale.getItem(param1);
         return BPLocale.getItem(param1);
      }
      
      public function get closeHintWindowOnMapJump() : Boolean
      {
         return this._closeHintWindowOnMapJump;
      }
      
      public function get contentName() : String
      {
         return this._contentName;
      }
   }
}

