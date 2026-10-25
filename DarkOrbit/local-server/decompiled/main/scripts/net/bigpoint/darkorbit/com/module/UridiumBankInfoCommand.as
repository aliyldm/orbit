package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UridiumBankInfoCommand implements IModule
   {
      
      private static var _instance:UridiumBankInfoCommand;
      
      public var maxValue:int = 0;
      
      public var textKey:String = "";
      
      public var secondsLeft:int = 0;
      
      public var price:String = "";
      
      public var imgKey:String = "";
      
      public var currentValue:int = 0;
      
      public function UridiumBankInfoCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:int = 0, param5:String = "", param6:String = "")
      {
         super();
         this.maxValue = param2;
         this.textKey = param5;
         this.secondsLeft = param4;
         this.price = param3;
         this.imgKey = param6;
         this.currentValue = param1;
      }
      
      public static function get instance() : UridiumBankInfoCommand
      {
         return _instance || (_instance = new UridiumBankInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21088;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.maxValue = param1.readInt();
         this.maxValue = this.maxValue >>> 9 % 32 | this.maxValue << 32 - 9 % 32;
         this.textKey = param1.readUTF();
         this.secondsLeft = param1.readInt();
         this.secondsLeft = this.secondsLeft << 13 % 32 | this.secondsLeft >>> 32 - 13 % 32;
         this.price = param1.readUTF();
         this.imgKey = param1.readUTF();
         this.currentValue = param1.readInt();
         this.currentValue = this.currentValue << 2 % 32 | this.currentValue >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(21088);
         param1.writeInt(this.maxValue << 9 % 32 | this.maxValue >>> 32 - 9 % 32);
         param1.writeUTF(this.textKey);
         param1.writeInt(this.secondsLeft >>> 13 % 32 | this.secondsLeft << 32 - 13 % 32);
         param1.writeUTF(this.price);
         param1.writeUTF(this.imgKey);
         param1.writeInt(this.currentValue >>> 2 % 32 | this.currentValue << 32 - 2 % 32);
      }
   }
}

