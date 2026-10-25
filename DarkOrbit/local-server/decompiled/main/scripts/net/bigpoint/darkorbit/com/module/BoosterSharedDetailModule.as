package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class BoosterSharedDetailModule extends BoosterDetailModule
   {
      
      private static var _instance:BoosterSharedDetailModule;
      
      public var numberOfBoosters:int = 0;
      
      public function BoosterSharedDetailModule(param1:String = "", param2:int = 0)
      {
         super(param1);
         this.numberOfBoosters = param2;
      }
      
      public static function get instance() : BoosterSharedDetailModule
      {
         return _instance || (_instance = new BoosterSharedDetailModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -9210;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.numberOfBoosters = param1.readInt();
         this.numberOfBoosters = this.numberOfBoosters << 2 % 32 | this.numberOfBoosters >>> 32 - 2 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-9210);
         super.write(param1);
         param1.writeInt(this.numberOfBoosters >>> 2 % 32 | this.numberOfBoosters << 32 - 2 % 32);
      }
   }
}

