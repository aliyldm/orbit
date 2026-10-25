package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ItemCommand implements IModule
   {
      
      private static var _instance:ItemCommand;
      
      public var toolTip:MessageKeyListWildcardCommand;
      
      public var visible:Boolean = false;
      
      public var itemId:String = "";
      
      public function ItemCommand(param1:String = "", param2:Boolean = false, param3:MessageKeyListWildcardCommand = null)
      {
         super();
         if(param3 == null)
         {
            this.toolTip = new MessageKeyListWildcardCommand();
         }
         else
         {
            this.toolTip = param3;
         }
         this.visible = param2;
         this.itemId = param1;
      }
      
      public static function get instance() : ItemCommand
      {
         return _instance || (_instance = new ItemCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12947;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.toolTip = MessageKeyListWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toolTip)
         {
            this.toolTip.read(param1);
         }
         this.visible = param1.readBoolean();
         this.itemId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12947);
         if(null != this.toolTip)
         {
            this.toolTip.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.visible);
         param1.writeUTF(this.itemId);
      }
   }
}

