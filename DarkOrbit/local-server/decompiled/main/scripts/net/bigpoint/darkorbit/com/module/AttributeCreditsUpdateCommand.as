package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeCreditsUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeCreditsUpdateCommand;
      
      public var credits:int = 0;
      
      public var uridium:int = 0;
      
      public var jackpot:Number = 0;
      
      public function AttributeCreditsUpdateCommand(param1:int = 0, param2:int = 0, param3:Number = 0)
      {
         super();
         this.credits = param1;
         this.uridium = param2;
         this.jackpot = param3;
      }
      
      public static function get instance() : AttributeCreditsUpdateCommand
      {
         return _instance || (_instance = new AttributeCreditsUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.credits = param1.readInt();
         this.credits = this.credits >>> 2 % 32 | this.credits << 32 - 2 % 32;
         this.uridium = param1.readInt();
         this.uridium = this.uridium >>> 13 % 32 | this.uridium << 32 - 13 % 32;
         this.jackpot = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9);
         param1.writeInt(this.credits << 2 % 32 | this.credits >>> 32 - 2 % 32);
         param1.writeInt(this.uridium << 13 % 32 | this.uridium >>> 32 - 13 % 32);
         param1.writeFloat(this.jackpot);
      }
   }
}

