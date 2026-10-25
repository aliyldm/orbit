package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionShowUiCommand implements IModule
   {
      
      private static var _instance:ExpeditionShowUiCommand;
      
      public static const UITYPE_NONE:int = 0;
      
      public static const UITYPE_TICKET:int = 1;
      
      public static const UITYPE_RESET:int = 2;
      
      public static const UITYPE_CLEAR_SHIP:int = 3;
      
      public static const UITYPE_CLEAR_ACTIVATE_SHIP:int = 4;
      
      public static const UITYPE_LEAVE:int = 5;
      
      public static const UITYPE_SELECT_ERR:int = 6;
      
      public static const UITYPE__MAX:int = 7;
      
      public var param1:String = "";
      
      public var type:int = 0;
      
      public var param0:String = "";
      
      public function ExpeditionShowUiCommand(param1:int = 0, param2:String = "", param3:String = "")
      {
         super();
         this.param1 = param3;
         this.type = param1;
         this.param0 = param2;
      }
      
      public static function get instance() : ExpeditionShowUiCommand
      {
         return _instance || (_instance = new ExpeditionShowUiCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4042;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.param1 = param1.readUTF();
         this.type = param1.readShort();
         this.param0 = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4042);
         param1.writeUTF(this.param1);
         param1.writeShort(this.type);
         param1.writeUTF(this.param0);
      }
   }
}

