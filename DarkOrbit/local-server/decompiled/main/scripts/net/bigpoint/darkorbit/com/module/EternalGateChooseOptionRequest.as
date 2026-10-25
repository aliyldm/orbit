package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateChooseOptionRequest implements IModule
   {
      
      private static var _instance:EternalGateChooseOptionRequest;
      
      public var choosenOption:int = 0;
      
      public function EternalGateChooseOptionRequest(param1:int = 0)
      {
         super();
         this.choosenOption = param1;
      }
      
      public static function get instance() : EternalGateChooseOptionRequest
      {
         return _instance || (_instance = new EternalGateChooseOptionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21881;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.choosenOption = param1.readInt();
         this.choosenOption = this.choosenOption >>> 8 % 32 | this.choosenOption << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(21881);
         param1.writeInt(this.choosenOption << 8 % 32 | this.choosenOption >>> 32 - 8 % 32);
      }
   }
}

