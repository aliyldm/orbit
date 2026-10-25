package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChrominUpdateCommand implements IModule
   {
      
      private static var _instance:ChrominUpdateCommand;
      
      public var currentAmt:Number = 0;
      
      public var maxAmt:Number = 0;
      
      public function ChrominUpdateCommand(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.currentAmt = param1;
         this.maxAmt = param2;
      }
      
      public static function get instance() : ChrominUpdateCommand
      {
         return _instance || (_instance = new ChrominUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6247;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentAmt = param1.readDouble();
         this.maxAmt = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6247);
         param1.writeDouble(this.currentAmt);
         param1.writeDouble(this.maxAmt);
      }
   }
}

