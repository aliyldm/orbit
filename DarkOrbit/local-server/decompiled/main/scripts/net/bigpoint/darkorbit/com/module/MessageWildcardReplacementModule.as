package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MessageWildcardReplacementModule implements IModule
   {
      
      private static var _instance:MessageWildcardReplacementModule;
      
      public var wildcard:String = "";
      
      public var replacement:String = "";
      
      public var replacementType:ReplacementTypeModule;
      
      public function MessageWildcardReplacementModule(param1:String = "", param2:String = "", param3:ReplacementTypeModule = null)
      {
         super();
         this.wildcard = param1;
         this.replacement = param2;
         if(param3 == null)
         {
            this.replacementType = new ReplacementTypeModule();
         }
         else
         {
            this.replacementType = param3;
         }
      }
      
      public static function get instance() : MessageWildcardReplacementModule
      {
         return _instance || (_instance = new MessageWildcardReplacementModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 48;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.wildcard = param1.readUTF();
         this.replacement = param1.readUTF();
         this.replacementType = ReplacementTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.replacementType)
         {
            this.replacementType.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(48);
         param1.writeUTF(this.wildcard);
         param1.writeUTF(this.replacement);
         if(null != this.replacementType)
         {
            this.replacementType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

