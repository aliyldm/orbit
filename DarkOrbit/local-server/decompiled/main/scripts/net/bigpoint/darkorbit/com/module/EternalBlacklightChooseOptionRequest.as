package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightChooseOptionRequest implements IModule
   {
      
      private static var _instance:EternalBlacklightChooseOptionRequest;
      
      public var choosenOption:int = 0;
      
      public function EternalBlacklightChooseOptionRequest(param1:int = 0)
      {
         super();
         this.choosenOption = param1;
      }
      
      public static function get instance() : EternalBlacklightChooseOptionRequest
      {
         return _instance || (_instance = new EternalBlacklightChooseOptionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18974;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.choosenOption = param1.readInt();
         this.choosenOption = this.choosenOption >>> 6 % 32 | this.choosenOption << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18974);
         param1.writeInt(this.choosenOption << 6 % 32 | this.choosenOption >>> 32 - 6 % 32);
      }
   }
}

