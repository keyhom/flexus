package flexus.inject.impl
{

import flash.system.ApplicationDomain;

import flexus.inject.*;
import flexus.metadata.*;

[ExcludeClass]
/**
 * A IInjector implemetation.
 *
 * @author keyhom.c
 */
internal class InjectorImpl implements IInjector
{

	public var proxy:IBindingProxy;

	/**
	 * Constructor.
	 *
	 * @param proxy
	 */
	public function InjectorImpl(proxy:IBindingProxy)
	{
		super();
		this.proxy = extendsFrom(proxy);
	}

	protected function extendsFrom(proxy:IBindingProxy):IBindingProxy
	{
		return new CascadeBindingProxy(this, proxy);
	}

	/**
	 * @{inheritDoc}
	 */
	public function injectInstance(instance:Object, domain:ApplicationDomain = null):void
	{
		var parser:MetadataParser = new MetadataParser;
		var info:IMetaInfo = parser.parse(instance);
		var mds:Vector.<IMetadata> = info.get(Inject) as Vector.<IMetadata>;

		if(mds && mds.length > 0)
		{
			for each(var m:IMetadata in mds)
			{
				var injectMeta:Inject = Inject(m);
				var element:IMetaElement = m.element;
				var cls:Class = element.type;
				
				if(!cls && element.typeName && domain)
				{
					cls = domain.getDefinition(element.typeName) as Class;
				}
				
				if(cls)
				{
					var named:String = injectMeta.named;
					var key:IKey = new SimpleKey(cls, named);
					var o:Array = this.proxy.lookup(key);
					if(o && o.length == 2)
					{
						var provider:IProvider = o[0] as IProvider;
						var scope:IScope = o[1] as IScope;
						provider = scope.runScope(key, provider);

						if(provider)
						{
							instance[element.name] = cls(new TransientContextProvider(this, provider).getInstance());
						}
					}
				}
			}
		}
	}
}
}

import flash.utils.Dictionary;

import flexus.inject.*;
import flexus.inject.impl.*;

/**
 * @author keyhom.c
 */
class TransientContextProvider implements IProvider
{
	/**
	 * @private
	 */
	static private const singletons:Dictionary = new Dictionary(true);

	private var injt:IInjector;
	private var provider:IProvider;

	/**
	 * Constructor.
	 *
	 * @param injt
	 * @param provider
	 */
	public function TransientContextProvider(injt:IInjector, provider:IProvider)
	{
		super();
		this.injt = injt;
		this.provider = provider;
	}

	public function getInstance():*
	{
		if(provider is InstanceProvider)
		{
			if(provider in singletons)
				return provider.getInstance();
			else
				singletons[provider] = true;
		}

		try
		{
			var o:Object = provider.getInstance();
			injt.injectInstance(o);
			return o;
		}
		finally
		{
			// clear in time.
			injt = null;
			provider = null;
		}
	}
}
