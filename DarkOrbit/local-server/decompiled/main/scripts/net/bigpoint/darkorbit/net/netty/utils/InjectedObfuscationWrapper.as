package net.bigpoint.darkorbit.net.netty.utils
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   
   public class InjectedObfuscationWrapper extends EventDispatcher
   {
      
      public static const MAX_INJECTION_LENGTH:uint = 4096;
      
      public static const HEADER_op:Array = [67,87,83,11,227,11,0,0,64,3,192,3,192,0,24,1,0,68,17,25,0,0,0,198,10,97,98,99,95,65,0];
      
      public static const FINISHER_op:Array = [10,19,1,0,0,0,100,105,100,73,68,0,64,0,0,0];
      
      private var HEADER_b:ByteArray = new ByteArray();
      
      private var FINISHER_b:ByteArray = new ByteArray();
      
      protected var _activated:Boolean;
      
      protected var _encoder:Object;
      
      protected var _encoderInitializedCallback:Function;
      
      protected var generatedSWF:ByteArray;
      
      public function InjectedObfuscationWrapper()
      {
         super();
      }
      
      protected function prepareFINISHER_() : void
      {
         var _loc3_:uint = 0;
         this.FINISHER_b = new ByteArray();
         var _loc1_:uint = FINISHER_op.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = uint(FINISHER_op[_loc2_]);
            this.FINISHER_b.writeByte(_loc3_);
            _loc2_++;
         }
      }
      
      protected function prepareHEADER_() : void
      {
         var _loc3_:uint = 0;
         this.HEADER_b = new ByteArray();
         var _loc1_:uint = HEADER_op.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = uint(HEADER_op[_loc2_]);
            this.HEADER_b.writeByte(_loc3_);
            _loc2_++;
         }
      }
      
      public function injectAndBuild(param1:ByteArray, param2:uint, param3:Function) : void
      {
         this._encoderInitializedCallback = param3;
         if(param2 > 0)
         {
            this.writeFilesizeIntoHeader(param2);
         }
         if(param1.length < MAX_INJECTION_LENGTH)
         {
            this.buildAlgorithm(param1);
         }
      }
      
      private function writeFilesizeIntoHeader(param1:uint) : void
      {
         var _loc2_:uint = uint(param1 & 0xFF);
         var _loc3_:uint = uint((param1 & 0xFF00) >> 8);
         var _loc4_:uint = uint((param1 & 0xFF0000) >> 16);
         var _loc5_:uint = uint((param1 & 0xFF000000) >> 24);
         HEADER_op[4] = _loc2_;
         HEADER_op[5] = _loc3_;
         HEADER_op[6] = _loc4_;
         HEADER_op[7] = _loc5_;
      }
      
      private function buildAlgorithm(param1:ByteArray) : void
      {
         this.prepareCodeSegments();
         this.generatedSWF = new ByteArray();
         this.generatedSWF.writeBytes(this.HEADER_b);
         this.generatedSWF.writeBytes(param1);
         this.generatedSWF.writeBytes(this.FINISHER_b);
         this.loadAlgorithm();
      }
      
      private function prepareCodeSegments() : void
      {
         this.prepareHEADER_();
         this.prepareFINISHER_();
      }
      
      protected function loadAlgorithm() : void
      {
         var _loc1_:Loader = new Loader();
         var _loc2_:LoaderInfo = _loc1_.contentLoaderInfo;
         _loc2_.addEventListener(Event.COMPLETE,this.handleAlgorithmLoadFinished);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.handleAlgorithmLoadIoError);
         _loc1_.loadBytes(this.generatedSWF);
      }
      
      private function handleAlgorithmLoadIoError(param1:IOErrorEvent) : void
      {
      }
      
      protected function handleAlgorithmLoadFinished(param1:Event = null) : void
      {
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.handleAlgorithmLoadFinished);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.handleAlgorithmLoadIoError);
         this._encoder = _loc2_.content;
         this.activate();
         this._encoderInitializedCallback();
      }
      
      public function decode(param1:ByteArray) : ByteArray
      {
         if(this.isActivated())
         {
            return this._encoder.decode(param1);
         }
         return param1;
      }
      
      public function encode(param1:ByteArray) : ByteArray
      {
         if(this._activated)
         {
            return this._encoder.encode(param1);
         }
         return param1;
      }
      
      private function testDeAndEncoding() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(255);
         _loc1_.writeByte(0);
         var _loc2_:ByteArray = this.encode(_loc1_);
         var _loc3_:ByteArray = this.decode(_loc2_);
      }
      
      public function activate() : void
      {
         this._activated = true;
      }
      
      public function deactivate() : void
      {
         this._activated = false;
      }
      
      public function isActivated() : Boolean
      {
         return this._activated;
      }
   }
}

