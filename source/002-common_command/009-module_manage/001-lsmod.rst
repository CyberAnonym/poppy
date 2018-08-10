lsmod
#####

查看模块信息
===============

.. code-block:: bash

    [root@alvin ~]# lsmod
    Module                  Size  Used by
    kvm_intel             170086  0
    kvm                   566340  1 kvm_intel
    irqbypass              13503  1 kvm
    rpcsec_gss_krb5        35549  0
    nfsv4                 574651  0
    dns_resolver           13140  1 nfsv4
    nfs                   261909  1 nfsv4
    fscache                64935  2 nfs,nfsv4
    snd_seq_midi           13565  0
    snd_seq_midi_event     14899  1 snd_seq_midi
    vmw_vsock_vmci_transport    30577  1
    vsock                  35327  2 vmw_vsock_vmci_transport
    coretemp               13444  0
    iosf_mbi               13523  0
    crc32_pclmul           13113  0
    ghash_clmulni_intel    13259  0
    snd_ens1371            25194  0
    snd_rawmidi            31294  2 snd_ens1371,snd_seq_midi
    snd_ac97_codec        130556  1 snd_ens1371
    ac97_bus               12730  1 snd_ac97_codec
    snd_seq                62699  2 snd_seq_midi_event,snd_seq_midi
    snd_seq_device         14356  3 snd_seq,snd_rawmidi,snd_seq_midi
    ppdev                  17671  0
    nfsd                  342857  1
    snd_pcm               106416  2 snd_ac97_codec,snd_ens1371
    snd_timer              29822  2 snd_pcm,snd_seq
    aesni_intel            69884  0
    lrw                    13286  1 aesni_intel
    gf128mul               14951  1 lrw
    glue_helper            13990  1 aesni_intel
    ablk_helper            13597  1 aesni_intel
    cryptd                 20359  3 ghash_clmulni_intel,aesni_intel,ablk_helper
    snd                    83383  7 snd_ac97_codec,snd_timer,snd_pcm,snd_seq,snd_rawmidi,snd_ens1371,snd_seq_device
    vmw_balloon            18190  0
    sg                     40721  0
    nfit                   49183  0
    joydev                 17377  0
    pcspkr                 12718  0
    soundcore              15047  1 snd
    libnvdimm             132047  1 nfit
    auth_rpcgss            59415  2 nfsd,rpcsec_gss_krb5
    vmw_vmci               67013  1 vmw_vsock_vmci_transport
    i2c_piix4              22390  0
    shpchp                 37032  0
    nfs_acl                12837  1 nfsd
    lockd                  93827  2 nfs,nfsd
    grace                  13515  2 nfsd,lockd
    sunrpc                348674  10 nfs,nfsd,rpcsec_gss_krb5,auth_rpcgss,lockd,nfsv4,nfs_acl
    parport_pc             28165  0
    parport                42299  2 ppdev,parport_pc
    ip_tables              27115  0
    xfs                   978100  2
    libcrc32c              12644  1 xfs
    sr_mod                 22416  0
    cdrom                  42556  1 sr_mod
    ata_generic            12910  0
    pata_acpi              13038  0
    sd_mod                 46322  3
    crc_t10dif             12714  1 sd_mod
    crct10dif_generic      12647  0
    vmwgfx                235405  1
    drm_kms_helper        159169  1 vmwgfx
    syscopyarea            12529  1 drm_kms_helper
    sysfillrect            12701  1 drm_kms_helper
    sysimgblt              12640  1 drm_kms_helper
    fb_sys_fops            12703  1 drm_kms_helper
    ttm                    99345  1 vmwgfx
    drm                   370825  4 ttm,drm_kms_helper,vmwgfx
    crct10dif_pclmul       14289  1
    crct10dif_common       12595  3 crct10dif_pclmul,crct10dif_generic,crc_t10dif
    crc32c_intel           22079  1
    ata_piix               35038  0
    libata                238896  3 pata_acpi,ata_generic,ata_piix
    serio_raw              13413  0
    mptspi                 22542  2
    scsi_transport_spi     30732  1 mptspi
    mptscsih               40150  1 mptspi
    e1000                 137500  0
    mptbase               105960  2 mptspi,mptscsih
    pcnet32                41545  0
    mii                    13934  1 pcnet32
    i2c_core               40756  3 drm,i2c_piix4,drm_kms_helper
    dm_mirror              22124  0
    dm_region_hash         20813  1 dm_mirror
    dm_log                 18411  2 dm_region_hash,dm_mirror
    dm_mod                123303  8 dm_log,dm_mirror
