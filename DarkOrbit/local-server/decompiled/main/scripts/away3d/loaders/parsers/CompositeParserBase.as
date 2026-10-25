package away3d.loaders.parsers
{
   import away3d.arcane;
   import away3d.library.assets.IAsset;
   import away3d.loaders.parsers.particleSubParsers.utils.SingleResourceDependency;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   use namespace arcane;
   
   public class CompositeParserBase extends ParserBase
   {
      
      private var _loadedAssetCache:Object = {};
      
      protected var _root:CompositeParserBase;
      
      protected var _children:Vector.<CompositeParserBase>;
      
      private var _childParsingComplete:Boolean;
      
      protected var _isFirstParsing:Boolean;
      
      private var _numProcessed:int;
      
      public function CompositeParserBase()
      {
         super(ParserDataFormat.PLAIN_TEXT);
         this._root = this;
      }
      
      public function get childParsingComplete() : Boolean
      {
         return this._childParsingComplete;
      }
      
      public function set childParsingComplete(param1:Boolean) : void
      {
         this._childParsingComplete = param1;
      }
      
      public function addSubParser(param1:CompositeParserBase) : void
      {
         this._children = this._children || new Vector.<CompositeParserBase>();
         if(this._children.indexOf(param1) != -1)
         {
            throw new Error("Duplicated add");
         }
         this._children.push(param1);
         param1.root = this._root;
      }
      
      override public function parseAsync(param1:*, param2:Number = 15) : void
      {
         if(param1 is String || param1 is ByteArray)
         {
            param1 = JSON.parse(param1);
         }
         this._numProcessed = 0;
         this._isFirstParsing = true;
         if(this._root == this)
         {
            super.parseAsync(param1,param2);
            this.onInterval();
         }
         else
         {
            _data = param1;
         }
      }
      
      override protected function onInterval(param1:TimerEvent = null) : void
      {
         super.onInterval(param1);
      }
      
      override protected function proceedParsing() : Boolean
      {
         this._isFirstParsing = false;
         if(this._root.dependencies.length)
         {
            this.pauseAndRetrieveDependencies();
            return MORE_TO_PARSE;
         }
         if(!this._children)
         {
            return PARSING_DONE;
         }
         while(this._numProcessed < this._children.length)
         {
            if(this._children[this._numProcessed].proceedParsing() != PARSING_DONE)
            {
               return MORE_TO_PARSE;
            }
            ++this._numProcessed;
         }
         return PARSING_DONE;
      }
      
      override protected function addDependency(param1:String, param2:URLRequest, param3:Boolean = false, param4:* = null, param5:Boolean = false) : void
      {
         this._root.dependencies.push(new SingleResourceDependency(param1,param2,param4,this,param3,param5));
      }
      
      override protected function finalizeAsset(param1:IAsset, param2:String = null) : void
      {
         if(this._root == this)
         {
            super.finalizeAsset(param1,param2);
         }
         else
         {
            this._root.finalizeAsset(param1,param2);
         }
      }
      
      override protected function hasTime() : Boolean
      {
         return this._root == this ? Boolean(super.hasTime()) : this._root.hasTime();
      }
      
      override public function set parsingFailure(param1:Boolean) : void
      {
         this._root.parsingFailure = param1;
         if(this._root == this)
         {
            super.parsingFailure = param1;
         }
         else
         {
            this._root.parsingFailure = param1;
         }
      }
      
      override public function get parsingFailure() : Boolean
      {
         return this._root == this ? super.parsingFailure : this._root.parsingFailure;
      }
      
      override protected function finishParsing() : void
      {
         if(this._root == this)
         {
            super.finishParsing();
         }
      }
      
      override protected function dieWithError(param1:String = "Unknown parsing error") : void
      {
         if(this._root == this)
         {
            super.dieWithError(param1);
         }
         else
         {
            this._root.dieWithError(param1);
         }
      }
      
      override protected function pauseAndRetrieveDependencies() : void
      {
         if(this._root == this)
         {
            super.pauseAndRetrieveDependencies();
         }
      }
      
      override public function get parsingPaused() : Boolean
      {
         return this._root == this ? super.parsingPaused : this._root.parsingPaused;
      }
      
      public function get root() : CompositeParserBase
      {
         return this._root;
      }
      
      public function set root(param1:CompositeParserBase) : void
      {
         var _loc2_:CompositeParserBase = null;
         this._root = param1;
         if(this._children)
         {
            for each(_loc2_ in this._children)
            {
               _loc2_.root = param1;
            }
         }
      }
      
      arcane function addAssets(param1:String, param2:Vector.<IAsset>) : void
      {
         this._loadedAssetCache[param1] = param2;
      }
      
      arcane function getAssets(param1:String) : Vector.<IAsset>
      {
         return this._loadedAssetCache[param1] as Vector.<IAsset>;
      }
   }
}

