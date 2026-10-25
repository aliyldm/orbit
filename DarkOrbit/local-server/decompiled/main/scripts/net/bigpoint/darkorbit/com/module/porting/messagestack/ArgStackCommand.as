package net.bigpoint.darkorbit.com.module.porting.messagestack
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ArgStackCommand implements IModule
   {
      
      private static var _instance:ArgStackCommand;
      
      public static const ARGKEY__COOLDOWN_:int = 0;
      
      public static const ARGKEY__BOOSTERNAME_:int = 1;
      
      public static const ARGKEY__module_:int = 2;
      
      public static const ARGKEY__level_:int = 3;
      
      public static const ARGKEY__date_:int = 4;
      
      public static const ARGKEY__userlevel_:int = 5;
      
      public static const ARGKEY__maxMessages_:int = 6;
      
      public static const ARGKEY__notesLimit_:int = 7;
      
      public static const ARGKEY__MINIMUM_BID_:int = 8;
      
      public static const ARGKEY__NAME_:int = 9;
      
      public static const ARGKEY__AMOUNT_:int = 10;
      
      public static const ARGKEY__CURRENCY_:int = 11;
      
      public static const ARGKEY_XXX:int = 12;
      
      public static const ARGKEY_YYY:int = 13;
      
      public static const ARGKEY_DATETIME:int = 14;
      
      public static const ARGKEY__MAX_BID_:int = 15;
      
      public static const ARGKEY__MAX:int = 16;
      
      public var type:int = 0;
      
      public var value2:BaseStackCommand;
      
      public var key:int = 0;
      
      public var value:String = "";
      
      public function ArgStackCommand(param1:int = 0, param2:int = 0, param3:String = "", param4:BaseStackCommand = null)
      {
         super();
         this.type = param2;
         if(param4 == null)
         {
            this.value2 = new BaseStackCommand();
         }
         else
         {
            this.value2 = param4;
         }
         this.key = param1;
         this.value = param3;
      }
      
      public static function get instance() : ArgStackCommand
      {
         return _instance || (_instance = new ArgStackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23459;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readInt();
         this.type = this.type << 4 % 32 | this.type >>> 32 - 4 % 32;
         this.value2 = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.value2)
         {
            this.value2.read(param1);
         }
         this.key = param1.readShort();
         this.value = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23459);
         param1.writeInt(this.type >>> 4 % 32 | this.type << 32 - 4 % 32);
         if(null != this.value2)
         {
            this.value2.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.key);
         param1.writeUTF(this.value);
      }
   }
}

