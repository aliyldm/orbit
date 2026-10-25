package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MenuItemToolTipReplacementCommand implements IModule
   {
      
      private static var _instance:MenuItemToolTipReplacementCommand;
      
      public var value:String = "";
      
      public var key:String = "";
      
      public function MenuItemToolTipReplacementCommand(param1:String = "", param2:String = "")
      {
         super();
         this.value = param2;
         this.key = param1;
      }
      
      public static function get instance() : MenuItemToolTipReplacementCommand
      {
         return _instance || (_instance = new MenuItemToolTipReplacementCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23501;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.value = param1.readUTF();
         this.key = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23501);
         param1.writeUTF(this.value);
         param1.writeUTF(this.key);
      }
   }
}

